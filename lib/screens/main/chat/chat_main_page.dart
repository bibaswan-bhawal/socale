// ignore_for_file: use_build_context_synchronously

import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/rounded_button.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/models/MatchRoom.dart';
import 'package:socale/models/RoomListItem.dart';
import 'package:socale/screens/main/chat/chat_page.dart';
import 'package:socale/screens/main/main_app.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/values/colors.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage>
    with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  late TabController _tabController;
  final TextEditingController controller = TextEditingController();
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  onItemClick(RoomListItem roomListItem) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ChatPage(room: MatchRoom(room: roomListItem)),
        transitionDuration: Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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

  Widget separatorBuilder(context, index) {
    return Padding(
      padding: EdgeInsets.only(left: 80),
      child: Divider(
        color: Color(0x2FFFFFFF),
      ),
    );
  }

  Widget listItem(RoomListItem roomListItem, int index) {
    return ListTile(
      minVerticalPadding: 15,
      tileColor: Color(0xFF292B2F),
      leading: ClipOval(
        child: roomListItem.getRoomPic,
      ),
      title: Text(
        roomListItem.getRoomName,
        style: GoogleFonts.poppins(
          color: Color(0xFFFFFFFF),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        roomListItem.getLastMessage,
        style: GoogleFonts.roboto(
          color: Color(0xA8FFFFFF),
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
      onTap: () => onItemClick(roomListItem),
    );
  }

  Widget listItemBuilder(context, animation, item, index) {
    return SizeFadeTransition(
      sizeFraction: 0.7,
      curve: Curves.easeInOut,
      animation: animation,
      child: listItem(item, index),
    );
  }

  Widget listEmptyMessage(String message) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width * 0.7,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: ColorValues.textOnDark,
                fontSize: MediaQuery.of(context).devicePixelRatio * 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RoundedButton(
              height: 54,
              width: size.width * 0.69,
              onClickEventHandler: () => {
                ref.read(mainPageController).animateToPage(1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubicEmphasized)
              },
              text: 'Start Matching',
              colors: [
                Color(0xFFFD6C00),
                Color(0xFFFFA133),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<RoomListItem>> roomState = ref.watch(roomsAsyncController);
    var size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        body: KeyboardSafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  SizedBox(
                    height: 75,
                    width: constraints.maxWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Image.asset('assets/images/socale_logo_bw.png', width: 50),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      width: size.width * 0.9,
                      height: 40,
                      child: TextFormField(
                        controller: _textEditingController,
                        onChanged: (value) => setState(() {}),
                        style: GoogleFonts.roboto(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          hintText: "Search",
                          hintStyle: GoogleFonts.roboto(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(style: BorderStyle.none, width: 0),
                          ),
                          fillColor: Color(0xFFB7B0B0).withOpacity(0.25),
                          filled: true,
                          isCollapsed: true,
                          contentPadding: EdgeInsets.only(top: 10),
                        ),
                      ),
                    ),
                  ),
                  TabBar(
                    splashFactory: NoSplash.splashFactory,
                    controller: _tabController,
                    indicatorWeight: 3,
                    indicatorColor: _selectedIndex == 0
                        ? ColorValues.socaleOrange
                        : Color(0xFFF151DD),
                    tabs: [
                      Tab(
                        child: Text(
                          "Your Network",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: _selectedIndex == 0
                                ? ColorValues.socaleOrange
                                : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Tab(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'New Matches',
                                style: GoogleFonts.poppins(
                                  color: _selectedIndex == 0
                                      ? Colors.white
                                      : Color(0xFFF151DD),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight - 205,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        roomState.when(
                          data: (List<RoomListItem> data) {
                            List<RoomListItem> networkRooms = [];

                            for (RoomListItem room in data) {
                              if (!room.showHidden() && !room.isDeleted()) {
                                networkRooms.add(room);
                              }
                            }

                            if (networkRooms.isEmpty) {
                              return listEmptyMessage("Hmm... Nothing is here yet");
                            }

                            if (_textEditingController.text.isNotEmpty) {
                              networkRooms = networkRooms
                                  .where((element) => element.getRoomName
                                      .toLowerCase()
                                      .contains(
                                          _textEditingController.text.toUpperCase()))
                                  .toList();
                            }

                            return ImplicitlyAnimatedList(
                              items: networkRooms,
                              areItemsTheSame: (RoomListItem room1, RoomListItem room2) =>
                                  room1.getRoom.id == room2.getRoom.id,
                              itemBuilder: listItemBuilder,
                            );
                          },
                          error: (Object error, StackTrace? stackTrace) {
                            throw (stackTrace.toString());
                          },
                          loading: () {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        roomState.when(
                          data: (List<RoomListItem> data) {
                            List<RoomListItem> matchRooms = [];

                            for (RoomListItem room in data) {
                              if (room.showHidden() && !room.isDeleted()) {
                                matchRooms.add(room);
                              }
                            }

                            if (_textEditingController.text.isNotEmpty) {
                              matchRooms = matchRooms
                                  .where((element) => element.getRoomName
                                      .toLowerCase()
                                      .contains(
                                          _textEditingController.text.toLowerCase()))
                                  .toList();
                            }

                            if (matchRooms.isEmpty) {
                              return listEmptyMessage(
                                  "Find your new matches to fill up this space!");
                            }

                            return ImplicitlyAnimatedList(
                              items: matchRooms,
                              areItemsTheSame: (RoomListItem room1, RoomListItem room2) =>
                                  room1.getRoom.id == room2.getRoom.id,
                              itemBuilder: listItemBuilder,
                              insertDuration: const Duration(milliseconds: 150),
                              removeDuration: const Duration(milliseconds: 150),
                            );
                          },
                          error: (Object error, StackTrace? stackTrace) {
                            throw (stackTrace.toString());
                          },
                          loading: () {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
