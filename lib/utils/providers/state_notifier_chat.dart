import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:socale/models/Message.dart';
import 'package:socale/models/RoomListItem.dart';

class ChatStateNotifier extends StateNotifier<AsyncValue<List<types.Message>>> {
  final RoomListItem room;
  StreamSubscription<QuerySnapshot<Message>>? _stream;

  ChatStateNotifier(this.room) : super(AsyncLoading()) {
    getMessages();
  }

  void getMessages() async {
    _stream = Amplify.DataStore.observeQuery(
      Message.classType,
      where: Message.ROOM.eq(room.getRoom.id),
      sortBy: [Message.CREATEDAT.descending()],
    ).listen((QuerySnapshot<Message> snapshot) {
      if (snapshot.isSynced) {
        List<types.Message> newMessages = [];

        for (Message message in snapshot.items) {
          print(message.author);

          newMessages.add(
            types.TextMessage(
              id: message.id,
              author: room.getChatUIUsers.where((user) => user.id == message.author.id).first,
              roomId: room.getRoom.id,
              text: message.text,
              createdAt: message.createdAt.getDateTimeInUtc().millisecondsSinceEpoch,
            ),
          );
        }

        state = AsyncData(newMessages);
      }
    });
  }
}
