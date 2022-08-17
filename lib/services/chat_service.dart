import 'package:amplify_api/model_queries.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:socale/models/UserRoom.dart';

import '../models/Message.dart';
import '../models/Room.dart';
import '../models/User.dart';

class ChatService {
  Future<User?> _getUserById(String id) async {
    final request = ModelQueries.get(User.classType, id);
    final response = await Amplify.API.query(request: request).response;

    return response.data;
  }

  Future<Room> createRoom(String otherUserId) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;

    Room room = Room();
    await Amplify.DataStore.save(room);

    await Amplify.DataStore.save(
        UserRoom(user: await _getUserById(userId), room: room));
    await Amplify.DataStore.save(
        UserRoom(user: await _getUserById(otherUserId), room: room));
    await Amplify.DataStore.save(UserRoom(
        user: await _getUserById("2875b3e5-8a63-4523-944a-ad8ba9184796"),
        room: room));

    return room;
  }

  Future<Room?> getRoom(String otherUserId) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;

    String GraphQLDocument = '''query getRoomsForUser(\$id: ID!) {
  listUserRooms(filter: {userID: {eq: "ed35fcbf-6fae-4c1d-9576-1af41f2bb3e6"}}) {
    items {
      id
      email
    }
  }
} ''';
  }

  // Future<List<Room>> getRoomsForCurrentUser() async {
  //   final userId = (await Amplify.Auth.getCurrentUser()).userId;
  //   final userRooms = await Amplify.DataStore.query(
  //     UserRoom.classType,
  //     where: UserRoom.USER.eq(userId),
  //   );
  //   return userRooms.map((userRoom) => userRoom.room).toList();
  // }
  //
  // Future<List<User>> getUsersForRoom(String roomId) async {
  //   final userRooms = await Amplify.DataStore.query(
  //     UserRoom.classType,
  //     where: UserRoom.ROOM.eq(roomId),
  //   );
  //   return userRooms.map((userRoom) => userRoom.user).toList();
  // }

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
    );

    print(user.email);
    print(message);
    await Amplify.DataStore.save(message);
    await Amplify.DataStore.save(currentRoom.copyWith(
      messages: currentRoom.messages == null ? [message] : currentRoom.messages!
        ..add(message),
    ));
  }

  Stream<List<Message>> listenToNewMessages(Room room, DateTime chatStartTime) {
    final messages = Amplify.DataStore.observeQuery(
      Message.classType,
      where: Message.ROOM.eq(room.id).and(Message.CREATEDAT.gt(chatStartTime)),
      sortBy: [Message.CREATEDAT.descending()],
    );
    return messages.map((message) => message.items);
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
