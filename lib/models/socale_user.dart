import 'package:cloud_firestore/cloud_firestore.dart';

class SocaleUser {
  final String uid;
  final String email;
  final DocumentSnapshot? doc;

  SocaleUser({
    required this.email,
    required this.uid,
    this.doc,
  });

  factory SocaleUser.nullUser() {
    return SocaleUser(
      uid: '',
      email: '',
    );
  }

  static Future<SocaleUser> fromUserId(String uid) async {
    if (uid == '') {
      return SocaleUser(
        uid: '',
        email: '',
      );
    }
    final doc =
        await FirebaseFirestore.instance.collection('accounts').doc(uid).get();
    return SocaleUser(
      uid: uid,
      email: doc["email"],
      doc: doc,
    );
  }
}
