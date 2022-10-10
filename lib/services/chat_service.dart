import 'dart:collection';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/models/RoomListItem.dart';
import 'package:socale/services/fetch_service.dart';

class ChatService {
  Future<RoomListItem> _createRoom(User currentUser, User otherUser) async {
    var isHiddenJsonObject = {
      currentUser.id: true,
      otherUser.id: true,
    };

    Room room = Room(
      isHidden: jsonEncode(isHiddenJsonObject),
      roomType: types.RoomType.direct.toString(),
      createdAt: TemporalDateTime.now(),
      updatedAt: TemporalDateTime.now(),
    );

    UserRoom userRoom1 = UserRoom(
      user: currentUser,
      room: room,
      createdAt: TemporalDateTime.now(),
      updatedAt: TemporalDateTime.now(),
    );

    UserRoom userRoom2 = UserRoom(
      user: otherUser,
      room: room,
      createdAt: TemporalDateTime.now(),
      updatedAt: TemporalDateTime.now(),
    );

    await Amplify.DataStore.save(room);

    await Amplify.DataStore.save(userRoom1);
    await Amplify.DataStore.save(userRoom2);

    return RoomListItem(room, [currentUser, otherUser], currentUser);
  }

  Future<RoomListItem?> getRoom(String otherUserId) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;

    User currentUser = await fetchService.fetchUserById(userId);
    User otherUser = await fetchService.fetchUserById(otherUserId);

    List<UserRoom> userRooms = await fetchService.fetchAllUserRoomsForUser(currentUser);
    List<UserRoom> otherUserRooms = await fetchService.fetchAllUserRoomsForUser(otherUser);

    HashMap<Room, bool> allRooms = HashMap<Room, bool>();
    List<Room> commonRooms = [];

    for (UserRoom userRoom in userRooms) {
      allRooms.putIfAbsent(userRoom.room, () => true);
    }

    for (UserRoom userRoom in otherUserRooms) {
      if (allRooms.putIfAbsent(userRoom.room, () => false)) {
        commonRooms.add(userRoom.room);
      }
    }

    if (commonRooms.isEmpty) {
      print(userRooms);
      print(otherUserRooms);
      return _createRoom(currentUser, otherUser);
    }

    RoomListItem roomListItem = RoomListItem(
      commonRooms.where((room) => room.roomType == types.RoomType.direct.toString()).first,
      [currentUser, otherUser],
      currentUser,
    );

    return roomListItem;
  }

  Future<void> sendMessage(String text, Room currentRoom) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    User user = (await Amplify.DataStore.query(User.classType, where: User.ID.eq(userId))).first;
    Room room = (await Amplify.DataStore.query(Room.classType, where: Room.ID.eq(currentRoom.id))).first;

    final message = Message(
      text: text,
      author: user,
      room: currentRoom,
      createdAt: TemporalDateTime.now(),
      updatedAt: TemporalDateTime.now(),
    );

    Room updatedRoom = room.copyWith(
      lastMessageSent: message.text,
      updatedAt: TemporalDateTime.now(),
    );

    await Amplify.DataStore.save(updatedRoom);
    await Amplify.DataStore.save(message);
  }
}

final chatService = ChatService();
