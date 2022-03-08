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
}

final userProvider =
    StateNotifierProvider<UserStateNotifier, SocaleUser>((ref) {
  return UserStateNotifier();
});
