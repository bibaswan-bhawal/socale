import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:socale/components/help_overplays/matches_help_overlay.dart';
import 'package:socale/models/User.dart';
import 'package:socale/screens/main/chat/chat_main_page.dart';
import 'package:socale/screens/main/matches/matches_page.dart';
import 'package:socale/screens/main/settings/settings_page.dart';
import 'package:socale/utils/providers/providers.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  final PageController _pageController = PageController(initialPage: 1);
  GlobalKey navBarKey = GlobalKey();

  bool _showMatchDialog = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final userState = ref.watch(userAsyncController);
    userState.whenData((user) => _showMatchDialog = !user.introMatchingCompleted);
  }

  _onDismiss() {
    setState(() => _showMatchDialog = false);
    final userState = ref.watch(userAsyncController);
    userState.whenData((user) {
      User updatedUser = user.copyWith(introMatchingCompleted: true);
      ref.read(userAsyncController.notifier).changeUserValue(updatedUser);
    });
  }

  handleBottomNavigationClick(value) {
    if (value == 1) ref.read(matchAsyncController.notifier).setLoading();
    _pageController.animateToPage(value, duration: Duration(milliseconds: 300), curve: Curves.easeInOutCubicEmphasized);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF292B2F),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    ChatListPage(),
                    MatchPage(),
                    SettingsPage(),
                  ],
                ),
              ),
              CustomBottomNavigationBar(
                key: navBarKey,
                size: size,
                onNavBarClicked: handleBottomNavigationClick,
              ),
            ],
          ),
          if (_showMatchDialog)
            MatchesHelpOverlay(
              onDismiss: _onDismiss,
            ),
        ],
      ),
    );
  }
}
//
