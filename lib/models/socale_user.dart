import 'package:cloud_firestore/cloud_firestore.dart';

class SocaleUser {
  final String uid;
  final String email;
  final Map<String, dynamic>? lastMessages;
  final DocumentSnapshot? doc;

  SocaleUser({
    required this.email,
    required this.uid,
    this.lastMessages,
    this.doc,
  });

  factory SocaleUser.nullUser() {
    return SocaleUser(
      uid: '',
      email: '',
      lastMessages: null,
    );
  }

  static Future<SocaleUser> fromUserId(String uid) async {
    if (uid == '') {
      return SocaleUser(
        uid: '',
        email: '',
        lastMessages: null,
      );
    }
    final doc =
        await FirebaseFirestore.instance.collection('accounts').doc(uid).get();
    return SocaleUser(
      uid: uid,
      email: doc["email"],
      lastMessages: (doc.data()?.containsKey('lastMessages') ?? false)
          ? doc["lastMessages"]
          : null,
      doc: doc,
    );
  }
}
