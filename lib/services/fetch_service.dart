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

  Future<List<User>?> fetchAllUsers() async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final users = await Amplify.DataStore.query(
      User.classType,
      where: User.ID.ne(userId),
    );

    return users;
  }

  Future<List<UserRoom>> fetchAllUserRoomsForUser(User user) async {
    List<UserRoom> userRooms = await Amplify.DataStore.query(UserRoom.classType, where: UserRoom.USER.eq(user.id));
    return userRooms;
  }

  Future<List<Room>> fetchAllRoomsForUser(User user) async {
    List<Room> rooms = [];

    final userRooms = await Amplify.DataStore.query(UserRoom.classType, where: UserRoom.USER.eq(user.id));

    for (UserRoom userRoom in userRooms) {
      Room room = userRoom.room;
      rooms.add(room);
    }

    rooms.sort((room1, room2) {
      return room1.updatedAt.compareTo(room2.updatedAt);
    });

    return rooms.reversed.toList();
  }

  Future<List<User>> fetchAllUsersByRoom(Room room) async {
    List<User> users = [];

    List<UserRoom> userRooms = await Amplify.DataStore.query(UserRoom.classType, where: UserRoom.ROOM.eq(room.id));

    for (UserRoom userRoom in userRooms) {
      users.add(userRoom.user);
    }

    return users;
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
