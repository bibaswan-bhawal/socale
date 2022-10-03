import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:socale/models/Room.dart';
import 'package:socale/models/UserRoom.dart';

class RoomsProvider extends StateNotifier<AsyncValue<List<Room>>> {
  final List<Room> rooms = [];
  StreamSubscription<QuerySnapshot<UserRoom>>? _stream;

  RoomsProvider() : super(AsyncLoading()) {
    print("search rooms");
    requestRooms();
  }

  Future<void> requestRooms() async {
    print("Searching for rooms.");
    final userId = (await Amplify.Auth.getCurrentUser()).userId;

    _stream = Amplify.DataStore.observeQuery(
      UserRoom.classType,
      where: UserRoom.USER.eq(userId),
    ).listen(
      (QuerySnapshot<UserRoom> snapshot) {
        if (snapshot.isSynced) {
          List<Room> newRooms = [];
          print("rooms");
          for (UserRoom userRoom in snapshot.items) {
            newRooms.addIf(userRoom.room != null, userRoom.room!);
          }

          newRooms.sort((room1, room2) {
            return room1.updatedAt!.compareTo(room2.updatedAt!);
          });
        }
      },
    );
  }
}
