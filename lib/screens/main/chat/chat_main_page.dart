// ignore_for_file: use_build_context_synchronously

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/screens/main/chat/chat_page.dart';
import 'package:socale/services/chat_service.dart';
import 'package:socale/services/fetch_service.dart';
import 'package:socale/utils/providers/providers.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  List<User> userList = [];
  List<Room> roomList = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getRooms();
  }

  getRooms() async {
    final userState = ref.watch(userAsyncController);
    userState.whenData((User user) async {
      print("got user rooms");
      List<Room> rooms = await fetchService.fetchAllRoomsForUser(user);
      List<User> _roomUsers = [];

      for (Room room in rooms) {
        List<User> roomUsers = await chatService.getUsersByRoom(room);

        User toAdd = roomUsers.where((otherUser) => otherUser.id != user.id).first;
        _roomUsers.add(toAdd);
      }

      setState(() => userList = _roomUsers);
      setState(() => roomList = rooms);
    });
  }

  onItemClick(int index) {
    Room room = roomList[index];

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ChatPage(
          room: room,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
              animation: animation, secondaryAnimation: secondaryAnimation, transitionType: SharedAxisTransitionType.horizontal, child: child);
        },
      ),
    );
  }

  buildListScreen(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            "Chats",
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.3,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
        Divider(
          color: Color(0x8AFFFFFF),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: ListView.separated(
              itemCount: roomList.length,
              separatorBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 80),
                  child: Divider(
                    color: Color(0x2FFFFFFF),
                  ),
                );
              },
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: Color(0xFF000000),
                  leading: CircleAvatar(
                    radius: 32,
                    child: Image.asset('assets/images/avatars/${userList[index].avatar}'),
                  ),
                  title: Text(
                    userList[index].anonymousUsername,
                    style: GoogleFonts.poppins(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    "Message",
                    style: GoogleFonts.roboto(
                      color: Color(0xA8FFFFFF),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () => onItemClick(index),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return KeyboardSafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: 58),
        child: buildListScreen(size),
      ),
    );
  }
}
