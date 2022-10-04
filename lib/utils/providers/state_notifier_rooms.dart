import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:socale/models/Room.dart';
import 'package:socale/models/UserRoom.dart';

class RoomsProvider extends StateNotifier<AsyncValue<List<Room>>> {
  final List<Room> rooms = [];
  StreamSubscription<QuerySnapshot<UserRoom>>? _streamUserRooms;
  StreamSubscription<QuerySnapshot<Room>>? _streamRooms;

  RoomsProvider() : super(AsyncLoading()) {
    print("search rooms");
    requestRooms();
  }

  Future<void> requestRooms() async {
    if (_streamUserRooms != null) {
      _streamUserRooms!.cancel();
    }

    print("Searching for rooms.");
    final userId = (await Amplify.Auth.getCurrentUser()).userId;

    _streamUserRooms = Amplify.DataStore.observeQuery(
      UserRoom.classType,
      where: UserRoom.USER.eq(userId),
    ).listen(
      (QuerySnapshot<UserRoom> snapshot) {
        if (snapshot.isSynced) {
          List<String> newRoomId = [];

          for (UserRoom userRoom in snapshot.items) {
            newRoomId.addIf(userRoom.room != null && !newRoomId.contains(userRoom.room!.id), userRoom.room!.id);
          }

          if (_streamRooms != null) {
            _streamRooms!.cancel();
          }

          print("updated user rooms: $newRoomId");
          QueryPredicate bob = Room.ID.eq(newRoomId[0]).or(Room.ID.eq(newRoomId[1]));

          _streamRooms = Amplify.DataStore.observeQuery(
            Room.classType,
          ).listen((QuerySnapshot<Room> snapshot) {
            if (snapshot.isSynced) {
              List<Room> newRooms = [];

              for (Room room in snapshot.items) {
                newRooms.addIf(!rooms.contains(room), room);
              }

              List<String> id = newRooms.map((e) => e.id).toList();

              print("Updated rooms: $id");
            }
          });
        }
      },
    );
  }
}
