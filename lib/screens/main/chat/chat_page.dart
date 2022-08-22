import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/services/chat_service.dart';

class ChatPage extends ConsumerStatefulWidget {
  final Room room;
  const ChatPage({Key? key, required this.room}) : super(key: key);

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  List<types.Message> _messages = [];
  StreamSubscription<QuerySnapshot<Message>>? _stream;
  late types.User _currentUser;
  final List<types.User> _users = [];
  bool _isUsersLoading = true;
  bool _isRoomNameLoading = true;
  late String _roomName;

  getRoomName() async {
    String currentUserId = (await Amplify.Auth.getCurrentUser()).userId;
    String roomName = "";

    for (types.User user in _users) {
      if (user.id != currentUserId) {
        roomName += "${user.firstName} ${user.lastName}";
      } else {
        print("bob");
        setState(
          () => _currentUser = types.User(
            id: user.id,
            firstName: user.firstName,
            lastName: user.lastName,
          ),
        );
      }
    }

    setState(() => _roomName = roomName);
    setState(() => _isRoomNameLoading = false);
  }

  getMessages() {
    _stream = Amplify.DataStore.observeQuery(Message.classType,
            where: Message.ROOM.eq(widget.room.id),
            sortBy: [Message.CREATEDAT.descending()])
        .listen((QuerySnapshot<Message> snapshot) {
      if (snapshot.isSynced) {
        List<types.Message> messages = [];
        for (Message message in snapshot.items) {
          print(message.createdAt.getDateTimeInUtc().millisecondsSinceEpoch);
          messages.add(
            types.TextMessage(
              id: message.id,
              author: _users
                  .where((element) => element.id == message.author.id)
                  .first,
              roomId: widget.room.id,
              text: message.encryptedText,
              createdAt:
                  message.createdAt.getDateTimeInUtc().millisecondsSinceEpoch,
            ),
          );
        }

        setState(() => _messages = messages);
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    _stream?.cancel();
  }

  prepareRoom() async {
    List<User> users = await chatService.getUsersByRoom(widget.room);
    if (users.isNotEmpty) {
      for (User user in users) {
        setState(
          () => _users.add(
            types.User(
              id: user.id,
              firstName: user.firstName,
              lastName: user.lastName,
            ),
          ),
        );
      }

      await getRoomName();
      getMessages();
      setState(() => _isUsersLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    prepareRoom();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            if (_isUsersLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
            if (!_isUsersLoading)
              Stack(
                children: [
                  chat_ui.Chat(
                    messages: _messages,
                    onSendPressed: _handleSendPressed,
                    user: _currentUser,
                    showUserNames: true,
                    theme: const chat_ui.DefaultChatTheme(
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
                  ),
                  SizedBox(
                    height: 90,
                    child: AppBar(
                      title: Text(_roomName),
                      backgroundColor: Color(0xFF292B2F),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    chatService.sendMessage(message.text, widget.room);
  }
}
