import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';

import 'ModelProvider.dart';

class RoomListItem implements Comparable<RoomListItem> {
  final Room _room;
  final List<User> _users;
  final User _currentUser;
  late types.User _currentChatUIUser;
  late List<types.User> _chatUIUsers;

  RoomListItem(this._room, this._users, this._currentUser) {
    print("Chat: creating RoomListItem with room $_room");

    Map<String, dynamic> isHiddenData = jsonDecode(_room.isHidden);

    _currentChatUIUser = types.User(
      id: _currentUser.id,
      firstName: _currentUser.firstName,
      lastName: _currentUser.lastName,
    );

    _chatUIUsers = [];

    for (User user in _users) {
      types.User userToAdd;

      if (isHiddenData[user.id]) {
        userToAdd = types.User(
          id: user.id,
          firstName: user.anonymousUsername.split(' ')[0],
          lastName: user.anonymousUsername.split(' ')[1],
        );
      } else {
        userToAdd = types.User(
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
        );
      }

      _chatUIUsers.addIf(!_chatUIUsers.contains(userToAdd), userToAdd);
    }
  }

  Room get getRoom => _room;
  List<User> get getUserList => _users;
  User get getCurrentUser => _currentUser;
  types.User get getCurrentChatUIUser => _currentChatUIUser;
  List<types.User> get getChatUIUsers => _chatUIUsers;

  String get getLastMessage {
    return _room.lastMessageSent != null ? _room.lastMessageSent!.text : "Send your first message!";
  }

  String get getRoomName {
    String roomName = "";
    Map<String, dynamic> map = jsonDecode(_room.isHidden);
    print(map);
    for (User user in _users) {
      if (user.id != _currentUser.id) {
        if (roomName.isEmpty) {
          if(map[user.id] == true){
            roomName = user.anonymousUsername;
            continue;
          }

          roomName = "${user.firstName} ${user.lastName}";
        } else {
          if(map[user.id]){
            roomName += "${user.firstName} ${user.lastName}";
            continue;
          }

          roomName = ", ${user.firstName} ${user.lastName}";
        }
      }
    }

    return roomName;
  }

  Widget get getRoomPic {
    if (_users.length == 2) {
      String profilePic = _users[0].id == _currentUser.id ? _users[1].avatar : _users[0].avatar;

      return CircleAvatar(
        radius: 32,
        child: Image.asset('assets/images/avatars/$profilePic'),
      );
    }

    String shortName = getRoomName;

    while (shortName.length > 3) {
      shortName = shortName.substring(0, shortName.length - 1);
    }

    return CircleAvatar(
      radius: 32,
      backgroundColor: Colors.brown.shade800,
      child: Text(shortName),
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is RoomListItem && runtimeType == other.runtimeType && _room.id == other._room.id;

  @override
  String toString() {
    return getRoomName;
  }

  @override
  int get hashCode => _room.id.hashCode;

  @override
  int compareTo(RoomListItem other) {
    print("sorting: $_room and ${other.getRoom}");
    return _room.updatedAt.compareTo(other._room.updatedAt);
  }
}
