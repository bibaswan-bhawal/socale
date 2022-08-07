import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/riverpods/global/tab_provider.dart';
import 'package:socale/riverpods/global/user_provider.dart';
import 'package:socale/utils/enums/tab_item.dart';

import '../account/account_screen/account_screen.dart';
import '../chat/chat_list_screen/chat_list_screen.dart';
import '../../../components/bottom_navigation_bar/bottom_navigation_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static List<Widget> screens = [
    ChatListScreen(),
    Center(child: Text('hj')),
    Consumer(builder: (context, ref, child) {
      final user = ref.watch(userProvider);
      return AccountScreen(userId: user.uid);
    })
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: const Color(0xff1F2124)));

    final Size size = MediaQuery.of(context).size;

    final tabItem = ref.watch(tabProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          IndexedStack(
            index: tabItemToIndex[tabItem]!,
            children: screens,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomBottomNavigationBar(
              size: size,
              onNavBarClicked: (tab) {
                ref.read(tabProvider.state).state = indexToTabItem[tab]!;
              },
            ),
          ),
        ],
      ),
    );
  }
}
