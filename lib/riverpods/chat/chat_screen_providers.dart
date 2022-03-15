import 'package:hooks_riverpod/hooks_riverpod.dart';

final chatScreenSearchFilterProvider = StateProvider<String>((ref) => '');

final chatScreenChatListProvider = FutureProvider<List>((ref) {
  final filter = ref.watch(chatScreenSearchFilterProvider);
  print(filter);
  // TODO: Complete Firebase filter and data pull logic
  return ['What’s up Saarth?', 'How\'s it going Aamish'];
});
