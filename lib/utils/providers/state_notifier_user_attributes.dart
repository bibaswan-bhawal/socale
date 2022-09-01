import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAttributesNotifier extends StateNotifier<AsyncValue<List<AuthUserAttribute>>> {
  UserAttributesNotifier() : super(AsyncLoading());

  Future<void> setAttributes() async {
    final attributes = (await Amplify.Auth.fetchUserAttributes());
    state = AsyncData(attributes);
  }
}
