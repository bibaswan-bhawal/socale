import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/services/aws_lambda_service.dart';
import 'package:socale/services/fetch_service.dart';

class MatchStateProvider extends StateNotifier<AsyncValue<Map<User, Match>>> {
  MatchStateProvider() : super(AsyncLoading());

  Future<void> setMatches(String id) async {
    Map<User, Match> matches = {};
    state = AsyncLoading();

    User currentUser = await fetchService.fetchUserById(id);

    if (currentUser.matches.isEmpty) {
      print("No matches found creating matches");

      Amplify.DataStore.stop();
      final response = await awsLambdaService.getMatches(id);
      Amplify.DataStore.start();

      if (response == false) {
        state = AsyncError("Could not fetch matches");
        return;
      }

      currentUser = await fetchService.fetchUserById(id);
    }

    for (String matchId in currentUser.matches) {
      User user = await fetchService.fetchUserById(matchId.split('_')[1]);
      Match match = await fetchService.fetchMatch(matchId);

      matches.addEntries([MapEntry(user, match)]);
    }

    if (matches.isEmpty) {
      state = AsyncError("Could not fetch matches");
      return;
    }

    state = AsyncData(matches);
  }

  void setLoading() {
    state = AsyncLoading();
  }

  void removeMatch() {
    if (state.hasValue) {
      if (state.value!.isNotEmpty) {
        User key = state.value!.keys.last;
        Map<User, Match> newState = state.value!;
        newState.remove(key);
        state = AsyncData(newState);
      }
    }
  }
}
