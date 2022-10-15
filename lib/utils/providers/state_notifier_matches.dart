import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/services/aws_lambda_service.dart';
import 'package:socale/services/fetch_service.dart';

class MatchStateNotifier extends StateNotifier<AsyncValue<Map<User, Match>>> {
  MatchStateNotifier() : super(AsyncLoading());

  Future<void> setMatches(String id) async {
    print("bob");
    final prefs = await SharedPreferences.getInstance();
    Map<User, Match> matches = {};
    state = AsyncLoading();

    User? currentUser = await fetchService.fetchUserById(id);

    String? lastUpdated = prefs.getString('lastUpdated');
    bool shouldUpdate = false;

    if (lastUpdated == null) {
      shouldUpdate = true;
    } else {
      if (DateTime.now().difference(DateTime.parse(lastUpdated)).inHours > 1) {
        shouldUpdate = true;
      }
    }

    if (currentUser == null) return;

    if (currentUser.matches.isEmpty || shouldUpdate) {
      await prefs.setString('lastUpdated', DateTime.now().toString());

      try {
        print("getting new matches");

        final response = await awsLambdaService.getMatches(id);
        if (response == false) {
          throw (Exception("Failed to generate matches"));
        }
      } catch (e, stackTrace) {
        state = AsyncError(e, stackTrace);
        return;
      }

      currentUser = await fetchService.fetchUserById(id);
      if (currentUser == null) return;
    }

    for (String matchId in currentUser.matches) {
      User? user = await fetchService.fetchUserById(matchId.split('_')[1]);
      if (user == null) continue;
      Match match = await fetchService.fetchMatch(matchId);

      matches.addEntries([MapEntry(user, match)]);
    }

    try {
      if (matches.isEmpty) {
        throw ("");
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return;
    }

    state = AsyncData(matches);
  }
}
