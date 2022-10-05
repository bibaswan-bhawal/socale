import 'dart:collection';
import 'dart:convert';

import 'package:amplify_api/model_queries.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:socale/models/RoomListItem.dart';
import 'package:socale/models/UserRoom.dart';
import 'package:socale/models/Message.dart';
import 'package:socale/models/Room.dart';
import 'package:socale/models/User.dart';
import 'package:socale/services/fetch_service.dart';

class ChatService {
  Future<List<User>> getUsersByRoom(Room room) async {
    List<User> users = [];

    List<UserRoom> userRooms = await Amplify.DataStore.query(UserRoom.classType, where: UserRoom.ROOM.eq(room.id));

    for (UserRoom userRoom in userRooms) {
      users.add(userRoom.user!);
    }

    return users;
  }

  Future<List<String>> getUserIdsByRoom(String roomId) async {
    String graphQLDocument = '''
    query getUsersForRoom(\$id: ID!) {
      listUserRooms(filter: {roomID: {eq: \$id}}) {
        items {
          user{
            id
          }
        }
      }
    } 
''';

    final request = GraphQLRequest(
      document: graphQLDocument,
      variables: <String, String>{'id': roomId},
    );

    final response = await Amplify.API.query(request: request).response;
    Map<String, dynamic> data = jsonDecode(response.data);
    List<dynamic> users = data['listUserRooms']['items'].map((room) => room['user']['id'].toString()).toList();

    return users.map((e) => e.toString()).toList();
  }

  Future<List<String>> getRoomIdsByUser(String userId) async {
    String graphQLDocument = '''
    query getRoomsForUser(\$id: ID!) {
      listUserRooms(filter: {userID: {eq: \$id}}) {
        items {
          room{
            id
          }
        }
      }
    } 
''';

    final request = GraphQLRequest(
      document: graphQLDocument,
      variables: <String, String>{'id': userId},
    );

    final response = await Amplify.API.query(request: request).response;
    Map<String, dynamic> data = jsonDecode(response.data);
    List<dynamic> rooms = data['listUserRooms']['items'].map((room) => room['room']['id'].toString()).toList();

    return rooms.map((e) => e.toString()).toList();
  }

  Future<User?> _getUserById(String id) async {
    final request = ModelQueries.get(User.classType, id);
    final response = await Amplify.API.query(request: request).response;

    return response.data;
  }

  Future<RoomListItem> _createRoom(String otherUserId) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;

    final currentUser = await _getUserById(userId);
    final otherUser = await _getUserById(otherUserId);

    var isHiddenJsonObject = {
      currentUser!.id: true,
      otherUser!.id: true,
    };

    Room room = Room(
      isHidden: jsonEncode(isHiddenJsonObject),
      createdAt: TemporalDateTime.now(),
      updateAt: TemporalDateTime.now(),
    );

    UserRoom userRoom1 = UserRoom(
      user: currentUser,
      room: room,
      createdAt: TemporalDateTime.now(),
      updateAt: TemporalDateTime.now(),
    );

    UserRoom userRoom2 = UserRoom(
      user: otherUser,
      room: room,
      createdAt: TemporalDateTime.now(),
      updateAt: TemporalDateTime.now(),
    );

    await Amplify.DataStore.save(room);

    await Amplify.DataStore.save(userRoom1);
    await Amplify.DataStore.save(userRoom2);

    return RoomListItem(room, [currentUser, otherUser], currentUser);
  }

  Future<RoomListItem> getRoom(String otherUserId) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;

    User currentUser = await fetchService.fetchUserById(userId);
    User otherUser = await fetchService.fetchUserById(otherUserId);

    List<String> userRooms = await getRoomIdsByUser(userId);
    List<String> otherUserRooms = await getRoomIdsByUser(otherUserId);

    HashMap<String, bool> allRooms = HashMap<String, bool>();
    List<String> commonRooms = [];

    for (String room in userRooms) {
      allRooms.putIfAbsent(room, () => true);
    }

    for (String room in otherUserRooms) {
      if (allRooms.putIfAbsent(room, () => false)) {
        commonRooms.add(room);
      }
    }

    if (commonRooms.isEmpty) {
      return await _createRoom(otherUserId);
    }

    for (String roomId in commonRooms) {
      List<String> users = await getUserIdsByRoom(roomId);

      if (users.length == 2) {
        Room room = (await Amplify.DataStore.query(Room.classType, where: Room.ID.eq(roomId))).first;
        return RoomListItem(room, [currentUser, otherUser], currentUser);
      }
    }

    return await _createRoom(otherUserId);
  }

  Future<User> getUser(String userId) async {
    return (await Amplify.DataStore.query(
      User.classType,
      where: User.ID.eq(userId),
    ))
        .first;
  }

  Future<void> sendMessage(String text, Room currentRoom) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;

    User user = (await Amplify.DataStore.query(
      User.classType,
      where: User.ID.eq(userId),
    ))
        .first;

    final message = Message(
      encryptedText: text,
      author: user,
      room: currentRoom,
      createdAt: TemporalDateTime.now(),
      updateAt: TemporalDateTime.now(),
    );

    Room updatedRoom = currentRoom.copyWith(lastMessage: text);
    print("Chat: Saving updated Room as: $updatedRoom");

    await Amplify.DataStore.save(updatedRoom);
    await Amplify.DataStore.save(message);
  }

  Future<List<Message>> queryMessages(Room room, int page) async {
    final messages = await Amplify.DataStore.query(
      Message.classType,
      where: Message.ROOM.eq(room.id),
      sortBy: [Message.CREATEDAT.descending()],
    );

    return messages;
  }
}

final chatService = ChatService();
