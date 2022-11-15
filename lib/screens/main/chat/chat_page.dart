import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/chat_loading.dart';
import 'package:socale/models/MatchRoom.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/models/RoomListItem.dart';
import 'package:socale/services/analytics_service.dart';
import 'package:socale/services/chat_service.dart';
import 'package:socale/services/mutate_service.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/values/colors.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool isDataLoading = true;
  bool isError = false;

  DateTime startTime = DateTime.now();
  @override
  void initState() {
    super.initState();

    print(widget.room);

    if (widget.room.room != null) {
      isDataLoading = false;
    }
  }

  @override
  void dispose() {
    analyticsService
        .recordChatSessionLength(DateTime.now().difference(startTime).inMilliseconds);
    super.dispose();
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// defualt behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              blockUser();
            },
            isDestructiveAction: true,
            child: const Text('Block'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              launchUrl(
                Uri.parse('https://tripetto.app/run/FA83WRYWJF'),
                mode: LaunchMode.externalApplication,
              );
            },
            child: const Text('Report'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void blockUser() async {
    final roomState = ref.watch(roomAsyncController(widget.room));
    final userState = ref.watch(userAsyncController);

    if (roomState.value != null) {
      await chatService.deleteRoom(roomState.value!.getRoom);
    }

    if (userState.value != null) {
      String matchToRemove =
          "${roomState.value!.getCurrentUser.id}_${roomState.value!.getUserList.firstWhere((element) => element.id != roomState.value!.getCurrentUser.id).id}";
      List<String> matches = userState.value!.matches;

      matches.remove(matchToRemove);

      User user = userState.value!.copyWith(matches: matches);
      await ref.read(userAsyncController.notifier).changeUserValue(user);
      ref.read(matchAsyncController.notifier).deleteMatch(matchToRemove);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final roomState = ref.watch(roomAsyncController(widget.room));

    return Scaffold(
      backgroundColor: Color(0xFF292B2F),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: roomState.when(data: (room) {
              return buildRoom(room);
            }, error: (error, stackTrace) {
              return errorPage();
            }, loading: () {
              return ChatLoading(isLoading: true);
            }),
          ),
        ],
      ),
    );
  }

  Widget errorPage() {
    return Stack(
      children: [
        AppBar(
          backgroundColor: ColorValues.socaleOrange,
        ),
        Center(
          child: Text(
            "There was an error loading your chats, \n Check your internet connection and restart the app.",
            style: GoogleFonts.roboto(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget buildRoom(RoomListItem room) {
    setState(() => showHiddenMessage = numMessages >= 50 && room.showHidden());
    var chatState = ref.watch(chatAsyncController(room));

    return Stack(
      children: [
        chatState.when(data: (messages) {
          setState(() => numMessages = messages.length);
          return chatRoomBuilder(messages, room);
        }, error: (error, stackTrace) {
          return errorPage();
        }, loading: () {
          return ChatLoading(isLoading: true);
        }),
        unlockBarBuilder(),
        shareProfileBuilder(room),
        appBarBuilder(room),
      ],
    );
  }

  Widget unlockBarBuilder() {
    final size = MediaQuery.of(context).size;
    double barHeight = size.height * 0.1;

    return Positioned(
      top: barHeight + MediaQuery.of(context).padding.top * 0.5,
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
        width: !showHiddenMessage ? size.width * (numMessages) / 49 : 0,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      ),
    );
  }

  Widget shareProfileBuilder(RoomListItem room) {
    final size = MediaQuery.of(context).size;

    double barHeight = size.height * 0.1;
    return AnimatedPositioned(
      top: showHiddenMessage ? (barHeight + MediaQuery.of(context).padding.top * 0.5) : 0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Material(
        elevation: 2,
        child: Container(
          color: Color(0xFF3E3E3E),
          width: size.width,
          height: barHeight + MediaQuery.of(context).padding.top * 0.5,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                width: 54,
                child: ClipOval(child: room.getRoomPic),
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
                          "You have been talking with a ${room.getRoomName} for a while now would you like to share your profile?",
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
                                foreground: Paint()
                                  ..shader = ColorValues.socaleTextGradient,
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
    );
  }

  void setIsHidden(RoomListItem roomListItem) async {
    if (!isLoading) {
      setState(() => isLoading = true);
      Room room = (await Amplify.DataStore.query(Room.classType,
              where: Room.ID.eq(roomListItem.getRoom.id)))
          .first;
      Map<String, dynamic> isHidden = jsonDecode(room.isHidden);

      isHidden[roomListItem.getCurrentUser.id] = false;

      Room updatedRoom = room.copyWith(
        isHidden: jsonEncode(isHidden),
        updatedAt: TemporalDateTime.now(),
      );

      await mutateService.updateModel(updatedRoom);

      RoomListItem newRoomList = roomListItem.copyWith(room: updatedRoom);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ChatPage(room: MatchRoom(room: newRoomList)),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              );
            },
          ),
        );
      }

      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget appBarBuilder(RoomListItem roomListItem) {
    final size = MediaQuery.of(context).size;

    double barHeight = size.height * 0.1;
    return Material(
      elevation: 1,
      child: Container(
        color: Color(0xFF292B2F),
        height: barHeight + MediaQuery.of(context).padding.top * 0.5,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                splashColor: Colors.transparent,
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: (barHeight / 2) * 0.6,
                ),
              ),
              ClipOval(
                child: CircleAvatar(
                  radius: (barHeight / 2) * 0.5,
                  child: roomListItem.getRoomPic,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: size.width * 0.035),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roomListItem.getRoomName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: barHeight * 0.2,
                      ),
                    ),
                    Text(
                      roomListItem.showHidden() ? "Anonymous Match" : "In your network",
                      style: GoogleFonts.poppins(
                        fontSize: barHeight * 0.12,
                        fontWeight: FontWeight.w400,
                        color: roomListItem.showHidden()
                            ? Color(0xFF9F78F3)
                            : ColorValues.socaleOrange,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                ),
              ),
              GestureDetector(
                onTap: () => _showActionSheet(context),
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: SvgPicture.asset('assets/icons/warning_icon.svg'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatRoomBuilder(
      List<types.Message> messages, RoomListItem roomListItem) {
    return chat_ui.Chat(
      messages: messages,
      onSendPressed: (types.PartialText message) =>
          _handleSendPressed(message, roomListItem),
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

  void _handleSendPressed(
      types.PartialText message, RoomListItem roomListItem) {
    chatService.sendMessage(message.text, roomListItem.getRoom);
  }
}
