import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/User.dart';
import 'package:socale/services/fetch_service.dart';
import 'package:socale/services/mutate_service.dart';

class UserStateNotifier extends StateNotifier<AsyncValue<User>> {
  UserStateNotifier() : super(AsyncLoading());

  Future<bool> setUser(String id) async {
    state = AsyncLoading();

    try {
      User? user = await fetchService.fetchUserById(id);
      if (user == null) throw Exception("could not get user");
      state = AsyncData(user);
      return true;
    } catch (e, stackTrace) {
      print(e);
      state = AsyncError(e, stackTrace);
      return false;
    }
  }

  Future<bool> changeUserValue(User user) async {
    print(state);
    print(user);
    state = AsyncData(user);
    User? updatedUser = await mutateService.updateModel(user) as User?;

    if (updatedUser == null) {
      return false;
    }

    return true;
  }

  void clearUser() {
    state = AsyncLoading();
  }
}
