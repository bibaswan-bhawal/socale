import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

final chatListScreenSearchFilterProvider = StateProvider<String>((ref) => '');

final chatListScreenChatListProvider = StreamProvider<List<types.Room>>((ref) {
  final filter = ref.watch(chatListScreenSearchFilterProvider).toLowerCase();
  return FirebaseChatCore.instance
      .rooms(orderByUpdatedAt: true)
      .map((roomList) {
    roomList.removeWhere((room) {
      bool isRoomToBeKept = false;
      if (room.type == types.RoomType.direct) {
        final user = room.users.firstWhere(
          (user) => user.id != FirebaseAuth.instance.currentUser!.uid,
          orElse: () => types.User(id: '', firstName: '', lastName: ''),
        );
        isRoomToBeKept = ((user.firstName ?? '') + ' ' + (user.lastName ?? ''))
            .toLowerCase()
            .contains(filter);
      } else {
        isRoomToBeKept = room.name?.toLowerCase().contains(filter) ?? true;
      }
      return filter.isNotEmpty ? !isRoomToBeKept : false;
    });
    return roomList;
  });
});
