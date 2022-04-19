// Chat-specific user data - to be replaced if chat mechanisms change
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final DateTime createdAt;
  final String firstName;
  final String lastName;
  final String imageUrl;
  final int lastSeen;
  final DateTime updatedAt;
  final String uid;
  final DocumentSnapshot? doc;

  UserData({
    required this.createdAt,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.lastSeen,
    required this.updatedAt,
    required this.uid,
    this.doc,
  });

  static Future<UserData?> fromUserId(String uid) async {
    if (uid == '') {
      return null;
    }
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return UserData(
      uid: uid,
      doc: doc,
      createdAt: (doc["createdAt"] as Timestamp).toDate(),
      firstName: doc["firstName"],
      lastName: doc["lastName"],
      imageUrl: doc["imageUrl"],
      lastSeen: doc["lastSeen"],
      updatedAt: (doc["updatedAt"] as Timestamp).toDate(),
    );
  }
}
