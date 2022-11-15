import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/services/aws_lambda_service.dart';
import 'package:socale/services/fetch_service.dart';

class MatchStateNotifier extends StateNotifier<AsyncValue<Map<User, Match>>> {
  MatchStateNotifier() : super(AsyncLoading());

  Future<bool> generateNewMatches() async {
    String userId = (await Amplify.Auth.getCurrentUser()).userId;
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await awsLambdaService.getMatches(userId);

      if (response == false) {
        throw (Exception("Failed to generate matches"));
      }

      prefs.setString("lastUpdated", DateTime.now().toString());
      return true;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return false;
    }
  }

  // Check if last time matches were updated was longer than 5 hours.
  Future<bool> shouldUpdateMatches() async {
    final prefs = await SharedPreferences.getInstance();

    DateTime lastUpdated = prefs.getString('lastUpdated') != null
        ? DateTime.parse(prefs.getString('lastUpdated')!)
        : DateTime.fromMillisecondsSinceEpoch(0);

    DateTime currentTime = DateTime.now();

    return currentTime.difference(lastUpdated).inHours > 5;
  }

  Future<void> setMatches() async {
    String userId = (await Amplify.Auth.getCurrentUser()).userId;
    User? currentUser = await fetchService.fetchUserById(userId);
    bool updateMatches = await shouldUpdateMatches();

    Map<User, Match> matches = {};

    state = AsyncLoading();

    try {
      if (currentUser == null) {
        throw (Exception("Failed to get user"));
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return;
    }

    if (updateMatches || currentUser.matches.isEmpty) {
      print("generating new matches");
      bool generatedMatches = await generateNewMatches();

      if (!generatedMatches) {
        return;
      }
    }

    for (String matchId in currentUser.matches) {
      User? user = await fetchService.fetchUserById(matchId.split('_')[1]);
      Match? match = await fetchService.fetchMatch(matchId);

      if (match == null || user == null) {
        await generateNewMatches();
        await setMatches();
        return;
      }

      matches.addEntries([MapEntry(user, match)]);
    }

    state = AsyncData(matches);
  }

  void deleteMatch(String id) {
    if (state.hasValue) {
      final currentMatches = state.value!;
      currentMatches.removeWhere((key, value) => value.id == id);

      state = AsyncData(currentMatches);
    }
  }
}
