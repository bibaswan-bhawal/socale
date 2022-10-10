import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/MatchRoom.dart';
import 'package:socale/models/RoomListItem.dart';
import 'package:socale/services/chat_service.dart';

class RoomStateNotifier extends StateNotifier<AsyncValue<RoomListItem>> {
  final MatchRoom matchRoom;

  RoomStateNotifier(this.matchRoom) : super(AsyncLoading()) {
    getRoom();
  }

  void getRoom() async {
    if (matchRoom.room != null) {
      state = AsyncData(matchRoom.room!);
    }

    if (matchRoom.user != null) {
      state = AsyncData((await chatService.getRoom(matchRoom.user!.id))!);
    }
  }
}
