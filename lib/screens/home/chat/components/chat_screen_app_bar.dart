import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';
import 'package:flappy_search_bar_ns/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:socale/theme/text_styles.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/size_config.dart';
import '../../../components/gap.dart';

class ChatScreenAppBar extends StatefulWidget implements PreferredSizeWidget {
  ChatScreenAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize =>
      Size.fromHeight(sx * (5 + 1 + 5 + 1 + 1) + sText * 5 + kToolbarHeight);

  @override
  State<ChatScreenAppBar> createState() => _ChatScreenAppBarState();
}

class _ChatScreenAppBarState extends State<ChatScreenAppBar> {
  final SearchBarController<int> searchBarController =
      SearchBarController<int>();

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
                searchBarController: searchBarController,
                // icon: Icon(Icons.search),
                textStyle: SocaleTextStyles.supportingText,
                iconActiveColor: Colors.amber,
                searchBarStyle: SearchBarStyle(
                  backgroundColor: SocaleColors.searchBarColor,
                  borderRadius: BorderRadius.circular(50),
                  padding: EdgeInsets.symmetric(horizontal: sx * 2),
                ),

                shrinkWrap: true,
                onItemFound: (item, int index) {
                  return Container();
                },
                onSearch: (String? text) async {
                  return <int>[];
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
