import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'ModelProvider.dart';

class RoomListItem implements Comparable<RoomListItem> {
  final Room _room;
  final List<User> _users;
  final User _currentUser;
  late types.User _currentChatUIUser;
  late List<types.User> _chatUIUsers;
  File? roomPic;

  RoomListItem(this._room, this._users, this._currentUser) {
    Map<String, dynamic> isHiddenData = jsonDecode(_room.isHidden);

    if (_users.length == 2) {
      bool isHidden = _users[0].id == _currentUser.id
          ? isProfileHidden(_users[1])
          : isProfileHidden(_users[0]);
      User userToGet = _users[0].id == _currentUser.id ? _users[1] : _users[0];
      if (!isHidden) {
        if (userToGet.profilePicture!.isNotEmpty) {
          fetchRoomPic(userToGet.profilePicture!);
        }
      }
    }

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

  Future<void> fetchRoomPic(String key) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = '${documentsDir.path}/$key.jpg';
    final file = File(filepath);

    try {
      await Amplify.Storage.downloadFile(
        key: key,
        local: file,
      );

      roomPic = file;
    } on StorageException catch (e) {
      print('Error downloading file: $e');
    }
  }

  Room get getRoom => _room;
  List<User> get getUserList => _users;
  User get getCurrentUser => _currentUser;
  types.User get getCurrentChatUIUser => _currentChatUIUser;
  List<types.User> get getChatUIUsers => _chatUIUsers;

  String get getLastMessage {
    return _room.lastMessageSent ?? "Send your first message!";
  }

  bool showHidden() {
    Map<String, dynamic> map = jsonDecode(_room.isHidden);

    for (User user in _users) {
      if (user.id == _currentUser.id) {
        return (map[user.id]);
      }
    }

    return false;
  }

  bool isProfileHidden(User otherUser) {
    Map<String, dynamic> map = jsonDecode(_room.isHidden);
    return (map[otherUser.id]);
  }

  String get getRoomName {
    String roomName = "";
    Map<String, dynamic> map = jsonDecode(_room.isHidden);
    for (User user in _users) {
      if (user.id != _currentUser.id) {
        if (roomName.isEmpty) {
          if (map[user.id] == true) {
            roomName = user.anonymousUsername;
            continue;
          }

          roomName = "${user.firstName} ${user.lastName}";
        } else {
          if (map[user.id]) {
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
      String avatarPic =
          _users[0].id == _currentUser.id ? _users[1].avatar : _users[0].avatar;
      bool isHidden = _users[0].id == _currentUser.id
          ? isProfileHidden(_users[1])
          : isProfileHidden(_users[0]);

      if (isHidden) {
        return Image.asset('assets/images/avatars/$avatarPic');
      } else {
        if (roomPic != null) {
          return Image.file(roomPic!);
        } else {
          return Image.asset('assets/images/avatars/$avatarPic');
        }
      }
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

  RoomListItem copyWith({Room? room, List<User>? users, User? currentUser}) {
    return RoomListItem(
      room ?? _room,
      users ?? _users,
      currentUser ?? _currentUser,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomListItem &&
          runtimeType == other.runtimeType &&
          _room.id == other._room.id;

  @override
  String toString() {
    return getRoomName;
  }

  @override
  int get hashCode => _room.id.hashCode;

  @override
  int compareTo(RoomListItem other) {
    return _room.updatedAt.compareTo(other._room.updatedAt);
  }
}
