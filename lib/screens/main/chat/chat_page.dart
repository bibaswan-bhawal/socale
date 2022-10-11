import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/models/MatchRoom.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/models/RoomListItem.dart';
import 'package:socale/services/chat_service.dart';
import 'package:socale/utils/constraints/constraints.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/values/colors.dart';

class ChatPage extends ConsumerStatefulWidget {
  final MatchRoom room;
  const ChatPage({Key? key, required this.room}) : super(key: key);

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  int numMessages = 0;
  int maxMessage = 0;
  bool showHiddenMessage = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var roomState = ref.watch(roomAsyncController(widget.room));

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          roomState.when(
              data: (room) {
                showHiddenMessage  = numMessages == 50 && room.showHidden();

                var chatState = ref.watch(chatAsyncController(room));
                return Stack(
                  children: [
                    chatState.when(data: (messages) {
                      setState(() => numMessages = messages.length);
                      return chatRoomBuilder(messages, room);
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
                      top: showHiddenMessage ? constraints.chatPageAppBarHeight : 0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Material(
                        elevation: 2,
                        child: Container(
                          color: Color(0xFF3E3E3E),
                          width: size.width,
                          height: 82,
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                width: 54,
                                child: room.getRoomPic,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 12, left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Looks like you are getting along!",
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 14,
                                          letterSpacing: -0.3,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 2),
                                        child: Text(
                                          "You have been talking with a crass Salmon for a while now would you like to share your profile?",
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white.withOpacity(0.5),
                                            fontSize: 12,
                                            letterSpacing: -0.3,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 20, left: 20),
                                child: GestureDetector(
                                  onTap: () => setIsHidden(room),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF686868),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    height: 32,
                                    width: 74,
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Share',
                                              style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: -0.3,
                                                foreground: Paint()..shader = ColorValues.socaleTextGradient,
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    appBarBuilder(room),
                  ],
                );
              },
              error: (error, stackTrace) {
                return Container();
              },
              loading: () {
                return Container();
              }),
        ],
      ),
    );
  }

  void setIsHidden(RoomListItem roomListItem) async {
    if (!isLoading) {
      setState(() => isLoading = true);
      Room room = (await Amplify.DataStore.query(Room.classType, where: Room.ID.eq(roomListItem.getRoom.id))).first;
      Map<String, dynamic> isHidden = jsonDecode(room.isHidden);

      isHidden[roomListItem.getCurrentUser.id] = false;

      Room updatedRoom = room.copyWith(
        isHidden: jsonEncode(isHidden),
        updatedAt: TemporalDateTime.now(),
      );

      await Amplify.DataStore.save(updatedRoom);

      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget appBarBuilder(RoomListItem roomListItem) {
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
                    roomListItem.getRoomPic,
                  ],
                ),
              ),
              leadingWidth: 112,
              title: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(roomListItem.getRoomName),
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

  Widget chatRoomBuilder(List<types.Message> messages, RoomListItem roomListItem) {
    return chat_ui.Chat(
      messages: messages,
      onSendPressed: (types.PartialText message) => _handleSendPressed(message, roomListItem),
      user: roomListItem.getCurrentChatUIUser,
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

  void _handleSendPressed(types.PartialText message, RoomListItem roomListItem) {
    print("Chat: Sending message in room: ${roomListItem.getRoom}");
    chatService.sendMessage(message.text, roomListItem.getRoom);
  }
}
