import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:socale/models/ModelProvider.dart';

class FetchService {
  final _db = Amplify.DataStore;

  Future<List<AuthUserAttribute>?> fetchCurrentUserAttributes() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      return result;
    } on AuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<User> fetchUserById(String userId) async {
    final request = ModelQueries.get(User.classType, userId);
    final response = await Amplify.API.query(request: request).response;
    print(response.errors);
    return response.data!;
  }

  Future<Match> fetchMatch(String matchId) async {
    final request = ModelQueries.get(Match.classType, matchId);
    final response = await Amplify.API.query(request: request).response;
    return response.data!;
  }

  Future<List<User>?> fetchAllUsers() async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final users = await Amplify.DataStore.query(
      User.classType,
      where: User.ID.ne(userId),
    );

    return users;
  }

  Future<List<Room>> fetchAllRoomsForUser(User user) async {
    List<Room> rooms = [];

    final userRooms = await Amplify.DataStore.query(UserRoom.classType, where: UserRoom.USER.eq(user.id));

    for (UserRoom userRoom in userRooms) {
      if (userRoom.room != null) {
        Room room = userRoom.room!;
        rooms.add(room);
      }
    }

    print(rooms);

    return rooms;
  }
}

final fetchService = FetchService();
