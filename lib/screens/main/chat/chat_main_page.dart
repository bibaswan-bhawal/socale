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
import 'package:socale/values/colors.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> with TickerProviderStateMixin {
  late TabController _tabController;
  List<User> userList = [];
  List<Room> roomList = [];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getRooms();
  }

  getRooms() async {
    final roomState = ref.watch(roomAsyncController);

    roomState.whenData((rooms) async {
      setState(() => roomList = rooms);
    });
  }

  onItemClick(int index) {
    // Room room = roomList[index];
    //
    // Navigator.of(context).push(
    //   PageRouteBuilder(
    //     pageBuilder: (context, animation, secondaryAnimation) => ChatPage(
    //       room: room,
    //     ),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return SharedAxisTransition(
    //           animation: animation, secondaryAnimation: secondaryAnimation, transitionType: SharedAxisTransitionType.horizontal, child: child);
    //     },
    //   ),
    // );
  }

  buildListScreen(Size size) {
    final roomState = ref.watch(roomAsyncController);

    return roomState.when(loading: () {
      return Container();
    }, error: (Object error, StackTrace? stackTrace) {
      return Container();
    }, data: (List<Room> rooms) {
      return ListView.separated(
        itemCount: rooms.length,
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
            leading: CircleAvatar(
              radius: 32,
              //child: Image.asset('assets/images/avatars/${userList[index].avatar}'),
            ),
            title: Text(
              "Hello", //userList[index].anonymousUsername,
              style: GoogleFonts.poppins(
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              rooms[index].lastMessage ?? "Send your first message!",
              style: GoogleFonts.roboto(
                color: Color(0xA8FFFFFF),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            onTap: () => onItemClick(index),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: KeyboardSafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  SizedBox(
                    height: 100,
                    width: constraints.maxWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Image.asset('assets/images/socale_logo_bw.png', width: 100),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      width: size.width * 0.9,
                      height: 40,
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search",
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
                    controller: _tabController,
                    indicatorWeight: 3,
                    indicatorColor: _selectedIndex == 0 ? ColorValues.socaleOrange : Color(0xFFF151DD),
                    tabs: [
                      Tab(
                        child: Text(
                          "Your Network",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: _selectedIndex == 0 ? [ColorValues.socaleOrange, ColorValues.socaleDarkOrange] : [Colors.white, Colors.white],
                              ).createShader(
                                Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                              ),
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = LinearGradient(
                                      colors: _selectedIndex == 1 ? [Color(0xFFF151DD), Color(0xFF7E3ECF)] : [Colors.white, Colors.white],
                                    ).createShader(
                                      Rect.fromLTWH(0.0, 0.0, 10.0, 20.0),
                                    ),
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
                    height: constraints.maxHeight - 199,
                    child: TabBarView(
                      children: [
                        Center(
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              "Build out your network to see them here",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: ColorValues.textOnDark,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        buildListScreen(size),
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
