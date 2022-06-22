import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/utils/constants.dart';

class ChatMessagesProvider extends StateNotifier<List<types.Message>> {
  final List<List<types.Message>> _allPagedResults = [];
  final types.Room room;
  Query<Map<String, dynamic>> currentQuery;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreMessages = true;

  ChatMessagesProvider(this.room)
      : currentQuery = FirebaseFirestore.instance
            .collection(
                '${FirebaseChatCore.instance.config.roomsCollectionName}/${room.id}/messages')
            .orderBy('createdAt', descending: true)
            .limit(numberOfMessagesPerPage),
        super([]) {
    requestMessages();
  }

  List<types.Message> _firestoreQuerySnapshotToMessageList(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.fold<List<types.Message>>(
      [],
      (previousValue, doc) {
        final data = doc.data();
        final author = room.users.firstWhere(
          (u) => u.id == data['authorId'],
          orElse: () => types.User(id: data['authorId'] as String),
        );

        data['author'] = author.toJson();
        data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
        data['id'] = doc.id;
        data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

        return [...previousValue, types.Message.fromJson(data)];
      },
    );
  }

  void requestMessages() {
    if (_lastDocument != null) {
      currentQuery = currentQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMoreMessages) return;

    final currentRequestIndex = _allPagedResults.length;

    currentQuery.snapshots().listen((messagesSnapshot) {
      final messages = _firestoreQuerySnapshotToMessageList(messagesSnapshot);
      final pageExists = currentRequestIndex < _allPagedResults.length;
      if (pageExists) {
        _allPagedResults[currentRequestIndex] = messages;
      } else {
        _allPagedResults.add(messages);
      }
      state = _allPagedResults.fold<List<types.Message>>(<types.Message>[],
          (previousValue, element) => previousValue..addAll(element));
      if (currentRequestIndex == _allPagedResults.length - 1) {
        _lastDocument = messagesSnapshot.docs.last;
      }
      _hasMoreMessages = messages.length == numberOfMessagesPerPage;
    });
  }
}

final chatMessagesProvider = StateNotifierProvider.family<ChatMessagesProvider,
    List<types.Message>, types.Room>((ref, room) {
  return ChatMessagesProvider(room);
});
