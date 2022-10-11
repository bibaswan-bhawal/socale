import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:socale/models/ModelProvider.dart';

class FetchService {
  Future<List<AuthUserAttribute>?> fetchCurrentUserAttributes() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      return result;
    } on AuthException catch (e) {
      throw (e.message);
    }
  }

  Future<User> fetchUserById(String userId) async {
    final request = ModelQueries.get(User.classType, userId);
    final response = await Amplify.API.query(request: request).response;

    if (response.errors.isNotEmpty) {
      throw ("Error fetching user by id at fetch service: ${response.errors}");
    }

    return response.data!;
  }

  Future<Match> fetchMatch(String matchId) async {
    final request = ModelQueries.get(Match.classType, matchId);
    final response = await Amplify.API.query(request: request).response;

    if (response.errors.isNotEmpty) {
      throw ("Error fetching match by id at fetch service: ${response.errors}");
    }

    return response.data!;
  }

  Future<List<UserRoom?>?> fetchAllUserRoomsForUser(User user) async {
    final request = ModelQueries.list(UserRoom.classType, where: UserRoom.USER.eq(user.id));
    final response = await Amplify.API.query(request: request).response;

    if (response.errors.isNotEmpty || response.data == null) {
      print("error getting user room for ${user.id}");
      return null;
    }

    return response.data!.items;
  }

  Future<List<User>> fetchAllUsersForRoom(Room room) async {
    List<User> users = [];

    final userRooms = await Amplify.DataStore.query(UserRoom.classType, where: UserRoom.ROOM.eq(room.id));

    for (UserRoom userRoom in userRooms) {
      users.add(userRoom.user);
    }

    return users;
  }
}

final fetchService = FetchService();
