import 'package:aws_common/aws_common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/User.dart';
import 'package:socale/services/fetch_service.dart';
import 'package:socale/services/update_service.dart';

class UserStateNotifier extends StateNotifier<AsyncValue<User>> {
  UserStateNotifier() : super(AsyncLoading());

  Future<bool> setUser(String id) async {
    state = AsyncLoading();

    try {
      User user = await fetchService.fetchUserById(id);
      state = AsyncData(user);
      return true;
    } catch (e) {
      print(e);
      state = AsyncError(e);
      return false;
    }
  }

  Future<bool> changeUserValue(User user) async {
    state = AsyncData(user);
    return await updateService.updateUser(user);
  }

  void clearUser() {
    safePrint("Clearing UserStateNotifier");
    state = AsyncLoading();
  }
}