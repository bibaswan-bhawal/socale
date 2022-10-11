import 'dart:collection';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/models/RoomListItem.dart';
import 'package:socale/services/fetch_service.dart';

class ChatService {
  Future<RoomListItem?> _createRoom(User currentUser, User otherUser) async {
    var isHiddenJsonObject = {
      currentUser.id: true,
      otherUser.id: true,
    };

    Room room = Room(
      isHidden: jsonEncode(isHiddenJsonObject),
      roomType: types.RoomType.direct.toString(),
      lastMessageSent: null,
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

    try {
      await Amplify.DataStore.save(room);

      await Amplify.DataStore.save(userRoom1);
      await Amplify.DataStore.save(userRoom2);

      return RoomListItem(room, [currentUser, otherUser], currentUser);
    } catch (e){
      return null;
    }
  }

  Future<RoomListItem?> getRoom(String otherUserId) async {

    final userId = (await Amplify.Auth.getCurrentUser()).userId;

    User currentUser = await fetchService.fetchUserById(userId);
    User otherUser = await fetchService.fetchUserById(otherUserId);

    try {
      List<UserRoom?>? userRooms = await fetchService.fetchAllUserRoomsForUser(currentUser);
      List<UserRoom?>? otherUserRooms = await fetchService.fetchAllUserRoomsForUser(otherUser);

      for(UserRoom? f in userRooms!){
        print(f!.id);
      }
      if(userRooms == null || otherUserRooms == null){
        print("could not get UserRooms");
        throw(Exception("Could not get UserRooms"));
      }

      HashMap<Room, bool> allRooms = HashMap<Room, bool>();
      List<Room> commonRooms = [];

      for (UserRoom? userRoom in userRooms) {
        if(userRoom == null) {
          print("user room somehow null for $userId");
          return null;
        }

        print("UserRoom: ${userRoom.room.id}");

        allRooms.putIfAbsent(userRoom.room, () => true);
      }

      for (UserRoom? userRoom in otherUserRooms) {
        if(userRoom == null) {
          print("user room somehow null for user $otherUserId");
          return null;
        }

        if (allRooms.putIfAbsent(userRoom.room, () => false)) {
          commonRooms.add(userRoom.room);
        }
      }

      if (commonRooms.isEmpty) {
        return _createRoom(currentUser, otherUser);
      }

      RoomListItem roomListItem = RoomListItem(
        commonRooms.where((room) => room.roomType == types.RoomType.direct.toString()).first,
        [currentUser, otherUser],
        currentUser,
      );

      return roomListItem;
    } catch (_) {
      rethrow;
    }
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
