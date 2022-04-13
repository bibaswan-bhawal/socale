import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../models/socale_user.dart';

class UserStateNotifier extends StateNotifier<SocaleUser> {
  UserStateNotifier() : super(SocaleUser.nullUser());

  void getUserData(String uid) async {
    state = await SocaleUser.fromUserId(uid);
  }

  void reset() {
    state = SocaleUser.nullUser();
  }

  void updateLastMessages(String roomId, String messageId) async {
    if (state.lastMessages != null &&
        state.lastMessages!.containsKey(roomId) &&
        state.lastMessages![roomId] == messageId) {
      print('Debounced');
      return;
    }

    final lastMessages = (state.lastMessages ?? {})..[roomId] = messageId;
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc(state.uid)
        .update({
      'lastMessages': lastMessages,
    });
    state = await SocaleUser.fromUserId(state.uid);
  }
}

final userProvider =
    StateNotifierProvider<UserStateNotifier, SocaleUser>((ref) {
  return UserStateNotifier();
});
