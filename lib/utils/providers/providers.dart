import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/utils/providers/state_notifier_chat.dart';
import 'package:socale/utils/providers/state_notifier_matches.dart';
import 'package:socale/utils/providers/state_notifier_rooms.dart';
import 'package:socale/utils/providers/state_notifier_user.dart';
import 'package:socale/utils/providers/state_notifier_user_attributes.dart';

final userAsyncController = StateNotifierProvider<UserStateNotifier, AsyncValue<User>>((ref) => UserStateNotifier());
final userAttributesAsyncController =
    StateNotifierProvider<UserAttributesNotifier, AsyncValue<List<AuthUserAttribute>>>((ref) => UserAttributesNotifier());
final chatAsyncController = StateNotifierProvider.family<ChatMessagesProvider, List<Message>, Room>((ref, room) => ChatMessagesProvider(room));
final matchAsyncController = StateNotifierProvider<MatchStateProvider, AsyncValue<Map<User, Match>>>((ref) => MatchStateProvider());
final roomAsyncController = StateNotifierProvider<RoomsProvider, AsyncValue<List<Room>>>((ref) => RoomsProvider());
