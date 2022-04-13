import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/riverpods/chat/chat_screen_providers.dart';
import 'package:socale/screens/home/chat/chat_list_screen/components/chat_tile.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:socale/theme/text_styles.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/size_config.dart';
import 'components/chat_screen_app_bar.dart';

class ChatListScreen extends ConsumerWidget {
  ChatListScreen({Key? key}) : super(key: key);
  final SearchBarController<int> controller = SearchBarController<int>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListStream = ref.watch(chatScreenChatListProvider.stream);
    return Scaffold(
      backgroundColor: SocaleColors.homeBackgroundColor,
      appBar: ChatScreenAppBar(
        searchBarController: controller,
      ),
      body: StreamBuilder(
          stream: chatListStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: SocaleColors.highlightColor,
                ),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'No chats available',
                  style: SocaleTextStyles.supportingText,
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: sx),
              child: ListView(
                children:
                    (snapshot.data as List<types.Room>).map((types.Room room) {
                  return ChatTile(room: room);
                }).toList(),
              ),
            );
          }),
    );
  }
}
