import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/riverpods/global/tab_provider.dart';
import 'package:socale/riverpods/global/user_provider.dart';
import 'package:socale/utils/enums/tab_item.dart';

import '../account/account_screen/account_screen.dart';
import '../chat/chat_list_screen/chat_list_screen.dart';
import '../CustomBottomNavigationBar.dart';

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
              ))
        ],
      ),
    );
  }
}

/*

     bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabItemToIndex[tabItem]!,
        backgroundColor: SocaleColors.bottomNavigationBarColor,
        selectedItemColor: SocaleColors.highlightColor,
        unselectedItemColor: SocaleColors.supportingTextColor,
        onTap: (index) {
          ref.read(tabProvider.state).state = indexToTabItem[index]!;
          print(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.crop_square_sharp),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '',
          ),
        ],
      ),
 */
