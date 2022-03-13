import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';
import 'package:flappy_search_bar_ns/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/theme/text_styles.dart';

import '../../../../riverpods/chat/chat_screen_providers.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/size_config.dart';
import '../../../components/gap.dart';

class ChatScreenAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  ChatScreenAppBar({Key? key, required this.searchBarController})
      : super(key: key);
  final SearchBarController<int> searchBarController;

  @override
  Size get preferredSize =>
      Size.fromHeight(sx * (5 + 1 + 5 + 1 + 1) + sText * 5 + kToolbarHeight);

  @override
  _ChatScreenAppBarState createState() => _ChatScreenAppBarState();
}

class _ChatScreenAppBarState extends ConsumerState<ChatScreenAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: SocaleColors.appBarBackgroundColor,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(sx * (5 + 1 + 5 + 1 + 1) + sText * 5),
        child: Column(
          children: [
            SizedBox.fromSize(
              size: Size(sy * 90, sx * 9),
              child: SearchBar(
                cancellationWidget: Text(
                  'Cancel',
                  style: SocaleTextStyles.supportingText,
                ),
                hintText: 'Search on Socale',
                hintStyle: SocaleTextStyles.textFieldHintText,
                searchBarController: widget.searchBarController,
                // icon: Icon(Icons.search),
                textStyle: SocaleTextStyles.supportingText,
                iconActiveColor: Colors.amber,
                searchBarStyle: SearchBarStyle(
                  backgroundColor: SocaleColors.searchBarColor,
                  borderRadius: BorderRadius.circular(50),
                  padding: EdgeInsets.symmetric(horizontal: sx * 2),
                ),
                shrinkWrap: true,
                debounceDuration: Duration(milliseconds: 500),
                onItemFound: (item, int index) {
                  return Container();
                },
                onSearch: (String? text) async {
                  // Updates filter state
                  final filterState =
                      ref.watch(chatScreenSearchFilterProvider.state);
                  filterState.update((state) => text ?? state);
                  return <int>[];
                },
                onCancelled: () {
                  final filterState =
                      ref.read(chatScreenSearchFilterProvider.state);
                  filterState.update((state) => '');
                },
              ),
            ),
            Gap(height: 1),
            Text('Your Chats', style: SocaleTextStyles.appBarHeading),
            Gap(height: 2),
          ],
        ),
      ),
      title: Image.asset(
        'assets/images/Socale-Splash-Logo.png',
        height: sx * 5,
      ),
    );
  }
}
