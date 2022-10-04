import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/models/RoomListItem.dart';
import 'package:socale/services/chat_service.dart';
import 'package:socale/utils/constraints/constraints.dart';

import '../../../models/ModelProvider.dart';

class ChatPage extends ConsumerStatefulWidget {
  final RoomListItem room;
  const ChatPage({Key? key, required this.room}) : super(key: key);

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  List<types.Message> _messages = [];
  StreamSubscription<QuerySnapshot<Message>>? _stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getMessages();
  }

  @override
  dispose() {
    super.dispose();
    _stream?.cancel();
  }

  void getMessages() {
    _stream = Amplify.DataStore.observeQuery(
      Message.classType,
      where: Message.ROOM.eq(widget.room.getRoom.id),
      sortBy: [Message.CREATEDAT.descending()],
    ).listen((QuerySnapshot<Message> snapshot) {
      if (snapshot.isSynced) {
        List<types.Message> newMessages = [];

        for (Message message in snapshot.items) {
          print("${widget.room.getChatUIUsers} said ${message.encryptedText}");

          newMessages.add(
            types.TextMessage(
              id: message.id,
              author: widget.room.getChatUIUsers.where((user) => user.id == message.author.id).first,
              roomId: widget.room.getRoom.id,
              text: message.encryptedText,
              createdAt: message.createdAt.getDateTimeInUtc().millisecondsSinceEpoch,
            ),
          );

          print(newMessages);
        }

        setState(() => _messages = newMessages);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          chatRoomBuilder(),
          appBarBuilder(),
        ],
      ),
    );
  }

  Widget appBarBuilder() {
    return SizedBox(
      height: constraints.chatPageAppBarHeight,
      child: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(top: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              widget.room.getRoomPic,
            ],
          ),
        ),
        leadingWidth: 112,
        title: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.room.getRoomName),
              Text(
                "Anonymous Match",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF9F78F3),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xFF292B2F),
      ),
    );
  }

  Widget chatRoomBuilder() {
    return chat_ui.Chat(
      messages: _messages,
      onSendPressed: _handleSendPressed,
      user: widget.room.getCurrentChatUIUser,
      showUserNames: true,
      theme: const chat_ui.DefaultChatTheme(
        primaryColor: Color(0xFFC022E5),
        backgroundColor: Color(0xFF292B2F),
        secondaryColor: Color(0xFF1F2124),
        receivedMessageBodyTextStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        sentMessageBodyTextStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    chatService.sendMessage(message.text, widget.room.getRoom);
  }
}
