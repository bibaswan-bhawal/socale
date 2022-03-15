import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/riverpods/chat/chat_screen_providers.dart';
import 'package:socale/screens/home/chat/chat_list_screen/components/chat_tile.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/size_config.dart';
import '../../../../theme/text_styles.dart';
import '../../../components/gap.dart';
import 'components/chat_screen_app_bar.dart';

class ChatListScreen extends ConsumerWidget {
  ChatListScreen({Key? key}) : super(key: key);
  final SearchBarController<int> controller = SearchBarController<int>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListFuture = ref.watch(chatScreenChatListProvider.future);
    return Scaffold(
      backgroundColor: SocaleColors.homeBackgroundColor,
      appBar: ChatScreenAppBar(
        searchBarController: controller,
      ),
      body: FutureBuilder(
          future: chatListFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return ListView(
              children: (snapshot.data as List).map((data) {
                print(snapshot);
                return ChatTile(message: data);
              }).toList(),
            );
          }),
    );
  }
}
