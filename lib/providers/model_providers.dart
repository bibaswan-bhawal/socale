import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/current_user.dart';
import 'package:socale/providers/model_notifiers/current_user_notifier.dart';

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, CurrentUser>((ref) => CurrentUserNotifier());
