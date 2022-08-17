import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/Message.dart';
import 'package:socale/models/Room.dart';
import 'package:socale/services/chat_service.dart';

class ChatMessagesProvider extends StateNotifier<List<Message>> {
  final Room room;
  final List<Message> _messageList = [];
  int page = 0;

  ChatMessagesProvider(Room _room)
      : room = _room,
        super([]) {
    requestMessages();
    chatService
        .listenToNewMessages(room, DateTime.now())
        .listen((newMessagesList) {
      state = List.from(newMessagesList)..addAll(_messageList);
    });
  }

  Future<bool> requestMessages() async {
    final oldMessagesList = await chatService.queryMessages(room, page);
    if (oldMessagesList.isEmpty) {
      return false;
    }
    state = _messageList..addAll(oldMessagesList);
    page++;
    return true;
  }
}

final chatMessagesProvider =
    StateNotifierProvider.family<ChatMessagesProvider, List<Message>, Room>(
        (ref, room) {
  return ChatMessagesProvider(room);
});
