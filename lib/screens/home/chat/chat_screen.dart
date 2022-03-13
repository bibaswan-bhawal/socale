import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/riverpods/chat/chat_screen_providers.dart';

import 'components/chat_screen_app_bar.dart';

class ChatScreen extends ConsumerWidget {
  ChatScreen({Key? key}) : super(key: key);
  final SearchBarController<int> controller = SearchBarController<int>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListFuture = ref.watch(chatScreenChatListProvider.future);
    return Scaffold(
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
                return ListTile(
                  title: Text(data!.toString()),
                );
              }).toList(),
            );
          }),
    );
  }
}
