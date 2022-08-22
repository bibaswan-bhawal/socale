import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:socale/components/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:socale/screens/main/chat/chat_main_page.dart';
import 'package:socale/screens/main/home/home_page.dart';
import 'package:socale/screens/main/insights/insights_page.dart';
import 'package:socale/screens/main/matches/card_provider.dart';
import 'package:socale/screens/main/matches/matches_page.dart';
import 'package:socale/screens/main/settings/settings_page.dart';
import 'package:socale/utils/providers/providers.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  final PageController _pageController = PageController(initialPage: 2);

  handleBottomNavigationClick(value) {
    final pageDistance = (_pageController.page! - value).abs();

    if (value == 2) {
      ref.read(matchAsyncController.notifier).setLoading();
    }

    if (pageDistance == 1) {
      _pageController.animateToPage(value,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOutCubicEmphasized);
    } else {
      _pageController.jumpToPage(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return Scaffold(
      backgroundColor: Color(0xFF292B2F),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    HomePage(),
                    ChatListPage(),
                    p.ChangeNotifierProvider(
                      create: (BuildContext context) => CardProvider(),
                      child: MatchPage(),
                    ),
                    InsightsPage(),
                    SettingsPage(),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomBottomNavigationBar(
                size: size,
                onNavBarClicked: handleBottomNavigationClick,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
