// ignore_for_file: use_build_context_synchronously

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/models/Room.dart';
import 'package:socale/models/User.dart';
import 'package:socale/screens/main/chat/chat_screen_provider.dart';
import 'package:socale/services/chat_service.dart';
import 'package:socale/services/fetch_service.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<User> userList = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  getUsers() async {
    for (User user in (await FetchService().fetchAllUsers())!) {
      setState(() => userList.add(user));
    }
  }

  getRoom(String otherUserId) async {
    Room? room = await chatService.getRoom(otherUserId);
    return room;
  }

  onItemClick(int index) async {
    Room? room = await getRoom(userList[index].id);

    if (room == null) {
      print("Could not fetch room");
      return;
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ChatScreenProvider(
            room: room,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child);
          },
        ),
      );
    }
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
              itemCount: userList.length,
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
                  tileColor: Color(0xFF292B2F),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xFF000000),
                    ),
                  ),
                  title: Text(
                    "${userList[index].firstName} ${userList[index].lastName!}",
                    style: GoogleFonts.poppins(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    userList[index].email,
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

    return Container(
      width: size.width,
      height: size.height,
      color: Color(0xFF292B2F),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 58),
          child: buildListScreen(size),
        ),
      ),
    );
  }
}
