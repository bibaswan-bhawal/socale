import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/current_user.dart';

class CurrentUserNotifier extends StateNotifier<CurrentUser> {
  AutoDisposeStateNotifierProviderRef ref;

  KeepAliveLink? disposeLink;

  CurrentUserNotifier(this.ref) : super(CurrentUser()) {
    disposeLink = ref.keepAlive();
  }

  setTokens({idToken, accessToken, refreshToken}) {
    state.setTokens(idToken: idToken, accessToken: accessToken, refreshToken: refreshToken);
  }

  @override
  dispose() {
    super.dispose();
    disposeLink?.close();
  }
}
