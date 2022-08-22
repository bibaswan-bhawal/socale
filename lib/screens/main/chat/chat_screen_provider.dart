import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/services/chat_service.dart';

class ChatScreenProvider extends ConsumerStatefulWidget {
  final Room room;
  const ChatScreenProvider({Key? key, required this.room}) : super(key: key);

  @override
  ConsumerState<ChatScreenProvider> createState() => _ChatScreenProviderState();
}

class _ChatScreenProviderState extends ConsumerState<ChatScreenProvider> {
  StreamSubscription<QuerySnapshot<Message>>? _stream;
  List<Message> _messages = [];
  List<User> users = [];

  void observeQuery() {
    _stream = Amplify.DataStore.observeQuery(
      Message.classType,
      where: Message.ROOM.eq(widget.room.id),
    ).listen((QuerySnapshot<Message> snapshot) {
      if (snapshot.isSynced) {
        setState(() {
          _messages = snapshot.items;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    observeQuery();
  }

  @override
  void dispose() {
    _stream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 100,
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      String message = _messages[index].encryptedText;
                      return ListTile(
                        title: Text(message),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    onSubmitted: (value) {
                      chatService.sendMessage(value, widget.room);
                    },
                    decoration: InputDecoration(
                      hintText: "Type text",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
