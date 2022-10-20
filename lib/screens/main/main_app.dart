import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:socale/components/help_overplays/matches_help_overlay.dart';
import 'package:socale/models/User.dart';
import 'package:socale/screens/main/chat/chat_main_page.dart';
import 'package:socale/screens/main/matches/matches_page.dart';
import 'package:socale/screens/main/profile/profile_page.dart';
import 'package:socale/services/notification_service.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/utils/system_ui_setter.dart';
import 'package:socale/values/colors.dart';

class MainApp extends ConsumerStatefulWidget {
  final bool? transitionAnimation;

  MainApp({Key? key, this.transitionAnimation}) : super(key: key);

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp>
    with TickerProviderStateMixin {
  bool? transitionAnimation;
  final PageController _pageController = PageController(initialPage: 1);
  final NotificationService notificationService = NotificationService();
  Animation<double>? containerAnimation;
  AnimationController? containerAnimationController;
  GlobalKey navBarKey = GlobalKey();
  bool _showMatchDialog = false;

  @override
  void initState() {
    super.initState();
    setSystemUILight();

    transitionAnimation = widget.transitionAnimation;
    notificationService.setWidgetRef(ref).init();
  }

  @override
  void dispose() {
    containerAnimationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final userState = ref.watch(userAsyncController);
    final matchState = ref.watch(matchAsyncController);

    if (transitionAnimation != null && transitionAnimation!) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        transitionAnimation = false;
        ref.read(matchAsyncController.notifier).setMatches(userState.value!.id);
        initialAnimation();
      });
    }

    userState.whenData((user) {
      _showMatchDialog = !user.introMatchingCompleted;
    });

    super.didChangeDependencies();
  }

  void initialAnimation() {
    final size = MediaQuery.of(context).size;

    containerAnimationController = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);
    containerAnimation = Tween<double>(begin: size.height, end: 0)
        .animate(containerAnimationController!)
      ..addListener(() {
        setState(() {});
      });

    containerAnimationController?.forward();
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
    _pageController.animateToPage(value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOutCubicEmphasized);
  }

  @override
  Widget build(BuildContext context) {
    final roomState = ref.watch(roomsAsyncController);
    roomState.whenData((value) => print("Got full room list"));

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
                    ProfilePage(),
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
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: size.width,
              height:
                  containerAnimation != null ? containerAnimation?.value : 0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorValues.socaleOrange,
                    ColorValues.socaleDarkOrange
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//
