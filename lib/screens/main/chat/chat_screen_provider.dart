import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/Message.dart';
import 'package:socale/models/Room.dart';
import 'package:socale/models/User.dart';
import 'package:socale/services/chat_service.dart';
import 'package:socale/utils/providers/chat_message_provider.dart';

class ChatScreenProvider extends ConsumerStatefulWidget {
  final Room room;
  const ChatScreenProvider({Key? key, required this.room}) : super(key: key);

  @override
  ConsumerState<ChatScreenProvider> createState() => _ChatScreenProviderState();
}

class _ChatScreenProviderState extends ConsumerState<ChatScreenProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Message> messages = ref.watch(chatMessagesProvider(widget.room));
    print("ROOM ID: " + widget.room.toString());
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  String message = messages[index].encryptedText;
                  String userEmail = messages[index].author.email;

                  return ListTile(
                    title: Text(message + " - " + userEmail),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: TextField(
                onSubmitted: (value) {
                  //chatService.sendMessage(value, widget.room);
                },
                decoration: InputDecoration(
                  hintText: "Type text",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
