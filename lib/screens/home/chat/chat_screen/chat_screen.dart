import 'dart:async';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socale/riverpods/global/user_provider.dart';

import '../../../../theme/text_styles.dart';

class ChatScreen extends ConsumerStatefulWidget {
  ChatScreen({Key? key}) : super(key: key);
  final types.Room room = Get.arguments as types.Room;

  @override
  ConsumerState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  StreamSubscription? _messageStreamSubscription;
  void _subscription(List<types.Message> messages) {
    if (messages.isEmpty) return;
    final userNotifier = ref.read(userProvider.notifier);
    userNotifier.updateLastMessages(widget.room.id, messages.first.id);
    print(messages.first);
  }

  @override
  void initState() {
    super.initState();
    _messageStreamSubscription =
        FirebaseChatCore.instance.messages(widget.room).listen(_subscription);
  }

  @override
  void dispose() async {
    _messageStreamSubscription?.cancel();
    super.dispose();
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );
    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final partialImage = types.PartialImage(
        height: image.height.toDouble(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      FirebaseChatCore.instance.sendMessage(
        partialImage,
        widget.room.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<types.Message>>(
          initialData: [],
          stream: FirebaseChatCore.instance.messages(widget.room),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'No message available',
                  style: SocaleTextStyles.supportingText,
                ),
              );
            }

            return SafeArea(
              bottom: false,
              child: Chat(
                showUserAvatars: true,
                showUserNames: true,
                user: widget.room.users.firstWhere(
                  (user) =>
                      user.id == FirebaseChatCore.instance.firebaseUser!.uid,
                  orElse: () => types.User(
                      id: FirebaseChatCore.instance.firebaseUser!.uid),
                ),
                messages: snapshot.data ?? [],
                onSendPressed: (partialText) {
                  FirebaseChatCore.instance.sendMessage(
                    partialText,
                    widget.room.id,
                  );
                },
                onAttachmentPressed: _handleImageSelection,
              ),
            );
          }),
    );
  }
}
