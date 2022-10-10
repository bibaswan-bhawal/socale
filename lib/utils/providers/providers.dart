import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/models/RoomListItem.dart';
import 'package:socale/utils/providers/state_notifier_chat.dart';
import 'package:socale/utils/providers/state_notifier_matches.dart';
import 'package:socale/utils/providers/state_notifier_rooms.dart';
import 'package:socale/utils/providers/state_notifier_user.dart';
import 'package:socale/utils/providers/state_notifier_user_attributes.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

final userAsyncController = StateNotifierProvider<UserStateNotifier, AsyncValue<User>>((ref) => UserStateNotifier());
final userAttributesAsyncController =
    StateNotifierProvider<UserAttributesNotifier, AsyncValue<List<AuthUserAttribute>>>((ref) => UserAttributesNotifier());
final chatAsyncController = StateNotifierProvider.autoDispose
    .family<ChatStateNotifier, AsyncValue<List<types.Message>>, RoomListItem>((ref, room) => ChatStateNotifier(room));
final matchAsyncController = StateNotifierProvider<MatchStateNotifier, AsyncValue<Map<User, Match>>>((ref) => MatchStateNotifier());
final roomAsyncController = StateNotifierProvider<RoomsStateNotifier, AsyncValue<List<RoomListItem>>>((ref) => RoomsStateNotifier());
