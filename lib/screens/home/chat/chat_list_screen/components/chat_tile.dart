import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/riverpods/global/user_provider.dart';

import '../../../../../theme/colors.dart';
import '../../../../../theme/size_config.dart';
import '../../../../../theme/text_styles.dart';
import '../../../../components/gap.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatTile extends ConsumerWidget {
  const ChatTile({Key? key, required this.room}) : super(key: key);

  final types.Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    types.Message? lastMessage = room.lastMessages?.first;
    String lastMessagePreview = '';
    if (lastMessage != null) {
      if (lastMessage.type == types.MessageType.text) {
        lastMessagePreview = (lastMessage as types.TextMessage).text;
      } else if (lastMessage.type == types.MessageType.image) {
        lastMessagePreview = '🖼️ Image';
      } else if (lastMessage.type == types.MessageType.file) {
        lastMessagePreview = '📁 File';
      } else if (lastMessage.type == types.MessageType.custom) {
        lastMessagePreview = '📝 Message';
      }
    }
    final user = ref.watch(userProvider);
    bool isUnread = true;
    if (lastMessage == null) {
      isUnread = false;
    }
    if (user.lastMessages != null &&
        user.lastMessages!.containsKey(room.id) &&
        lastMessage != null) {
      isUnread = user.lastMessages![room.id] != lastMessage.id;
    }
    return ListTile(
      onTap: () => Get.toNamed('/chat', arguments: room),
      title: Container(
        height: sx * 11,
        width: sy * 80,
        padding: EdgeInsets.symmetric(
          vertical: sx * 2,
          horizontal: sy * 3,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          color: SocaleColors.bottomNavigationBarColor,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: sx * 4,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                FirebaseAuth.instance.currentUser!.photoURL!,
              ),
            ),
            Gap(width: 3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.users
                        .singleWhere((user) =>
                            user.id != FirebaseAuth.instance.currentUser!.uid)
                        .firstName!,
                    style: SocaleTextStyles.chatHeading,
                  ),
                  Gap(height: 1),
                  Expanded(
                    child: Text(
                      lastMessagePreview.length > 100
                          ? lastMessagePreview.substring(0, 100) + '...'
                          : lastMessagePreview,
                      overflow: TextOverflow.fade,
                      style: SocaleTextStyles.supportingText,
                    ),
                  ),
                ],
              ),
            ),
            if (isUnread)
              Align(
                alignment: Alignment.centerRight,
                child: Text('❗️'),
              ),
          ],
        ),
      ),
    );
  }
}
