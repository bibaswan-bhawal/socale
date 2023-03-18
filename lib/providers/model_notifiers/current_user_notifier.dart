import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/user/current_user/current_user.dart';

class CurrentUserNotifier extends StateNotifier<CurrentUser> {
  AutoDisposeStateNotifierProviderRef ref;

  KeepAliveLink? disposeLink;

  CurrentUserNotifier(this.ref) : super(const CurrentUser()) {
    disposeLink = ref.keepAlive();
  }

  setId(value) => state = state.copyWith(id: value);

  setEmail(value) => state = state.copyWith(email: value);

  setCollegeEmail(value) => state = state.copyWith(collegeEmail: value);

  setCollege(value) => state = state.copyWith(college: value);

  setFirstName(value) => state = state.copyWith(firstName: value);

  setLastName(value) => state = state.copyWith(lastName: value);

  setTokens({JsonWebToken? idToken, JsonWebToken? accessToken, String? refreshToken}) => state = state.copyWith(
        idToken: idToken,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

  disposeState() {
    disposeLink?.close();
  }
}
