import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/models/RoomListItem.dart';
import 'package:socale/services/chat_service.dart';
import 'package:socale/utils/constraints/constraints.dart';
import 'package:socale/utils/providers/providers.dart';

class ChatPage extends ConsumerStatefulWidget {
  final RoomListItem room;
  const ChatPage({Key? key, required this.room}) : super(key: key);

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  int numMessages = 0;
  int maxMessage = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var chatState = ref.watch(chatAsyncController(widget.room));
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          chatState.when(data: (messages) {
            setState(() => numMessages = messages.length);
            return chatRoomBuilder(messages);
          }, error: (error, stackTrace) {
            return Container();
          }, loading: () {
            return Container();
          }),
          Positioned(
            top: constraints.chatPageAppBarHeight,
            child: AnimatedContainer(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF1A2A6C),
                    Color(0xFFFF0080),
                    Color(0xFFFDBB2D),
                  ],
                ),
              ),
              height: 4,
              width: size.width * (numMessages) / 50,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            ),
          ),
          AnimatedPositioned(
            top: numMessages == 50 ? 0 : constraints.chatPageAppBarHeight,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            child: Material(
              elevation: 2,
              child: Container(
                color: Color(0xFF3E3E3E),
                width: size.width,
                height: 82,
                child: Text("bob"),
              ),
            ),
          ),
          appBarBuilder(),
        ],
      ),
    );
  }

  Widget appBarBuilder() {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: constraints.chatPageAppBarHeight,
      child: Column(
        children: [
          SizedBox(
            height: constraints.chatPageAppBarHeight,
            child: AppBar(
              leading: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      splashColor: Colors.transparent,
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
          ),
        ],
      ),
    );
  }

  Widget chatRoomBuilder(List<types.Message> messages) {
    return chat_ui.Chat(
      messages: messages,
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
    print("Chat: Sending message in room: ${widget.room.getRoom}");
    chatService.sendMessage(message.text, widget.room.getRoom);
  }
}
