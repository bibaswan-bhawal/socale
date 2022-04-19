import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/models/user_data.dart';

final userDataProvider =
    FutureProvider.family.autoDispose<UserData?, String>((ref, userId) async {
  final userData = await UserData.fromUserId(userId);
  return userData;
});
