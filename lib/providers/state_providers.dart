import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/app_state.dart';
import 'package:socale/models/auth_state.dart';
import 'package:socale/providers/state_notifiers/app_state_notifier.dart';
import 'package:socale/providers/state_notifiers/auth_state_notifier.dart';

final appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((ref) => AppStateNotifier());
final authStateProvider =
    StateNotifierProvider.autoDispose<AuthStateNotifier, AuthState>((ref) => AuthStateNotifier());
