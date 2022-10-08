import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/services/aws_lambda_service.dart';
import 'package:socale/services/fetch_service.dart';

class MatchStateProvider extends StateNotifier<AsyncValue<Map<User, Match>>> {
  MatchStateProvider() : super(AsyncLoading());

  Future<void> setMatches(String id) async {
    print("MessageProvider: message provider getting matches.");
    Map<User, Match> matches = {};
    state = AsyncLoading();

    User currentUser = await fetchService.fetchUserById(id);

    if (currentUser.matches.isEmpty) {
      try {
        Amplify.DataStore.stop();
        final response = await awsLambdaService.getMatches(id);
        Amplify.DataStore.start();

        if (response == false) {
          throw ("");
        }
      } catch (e, stackTrace) {
        state = AsyncError(e, stackTrace);
        return;
      }

      currentUser = await fetchService.fetchUserById(id);
    }

    for (String matchId in currentUser.matches) {
      print(matchId);
      User user = await fetchService.fetchUserById(matchId.split('_')[1]);
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
