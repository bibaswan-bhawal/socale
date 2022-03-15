import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );
    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final message = types.ImageMessage(
        author: types.User(id: 'asa', firstName: 'Lauren'),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: uuid.v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );
      _addMessage(message);
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Chat(
          showUserAvatars: true,
          showUserNames: true,
          user: types.User(id: 'saa'),
          messages: _messages,
          onSendPressed: (partialText) {},
          onAttachmentPressed: _handleImageSelection,
        ),
      ),
    );
  }
}
