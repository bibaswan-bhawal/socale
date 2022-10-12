import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/MatchRoom.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/models/RoomListItem.dart';
import 'package:socale/services/chat_service.dart';

class RoomStateNotifier extends StateNotifier<AsyncValue<RoomListItem>> {
  final MatchRoom matchRoom;
  StreamSubscription<QuerySnapshot<Room>>? _stream;

  RoomStateNotifier(this.matchRoom) : super(AsyncLoading()) {
    getRoom();
  }

  @override
  void dispose() {
    super.dispose();
    _stream?.cancel();
  }

  void getRoom() async {
    if (matchRoom.room != null) {
      state = AsyncData(matchRoom.room!);
    }

    if (matchRoom.user != null) {
      try {
        RoomListItem? roomListItem =
            await chatService.getRoom(matchRoom.user!.id);
        if (roomListItem == null) throw (Exception("couldn't get room"));

        state = AsyncData(roomListItem);
      } catch (error, stackTrace) {
        print(error);
        state = AsyncError(error, stackTrace);
        return;
      }
    } else {
      return;
    }

    _stream = Amplify.DataStore.observeQuery(
      Room.classType,
      where: Room.ID.eq(state.value!.getRoom.id),
    ).listen((QuerySnapshot snapshot) {
      if (snapshot.isSynced) {
        Room room = snapshot.items.first as Room;
        RoomListItem newRoomListItem = RoomListItem(
            room, state.value!.getUserList, state.value!.getCurrentUser);
        state = AsyncData(newRoomListItem);
      }
    });
  }
}
