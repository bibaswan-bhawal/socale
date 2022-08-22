import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/Message.dart';
import 'package:socale/models/Room.dart';
import 'package:socale/services/chat_service.dart';

class ChatMessagesProvider extends StateNotifier<List<Message>> {
  final Room room;
  final List<Message> _messageList = [];
  int page = 0;

  ChatMessagesProvider(this.room) : super([]) {
    requestMessages();
    chatService.listenToNewMessages(room, DateTime.now());
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
