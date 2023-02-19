import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/current_user.dart';

class CurrentUserNotifier extends StateNotifier<CurrentUser> {
  CurrentUserNotifier() : super(CurrentUser());

  setTokens({idToken, accessToken, refreshToken}) {
    state.setTokens(idToken: idToken, accessToken: accessToken, refreshToken: refreshToken);
  }
}
