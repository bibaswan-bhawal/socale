import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

@lazySingleton
class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    if (userCredential.additionalUserInfo!.isNewUser) {
      _firebaseFirestore
          .collection('accounts')
          .doc(userCredential.user?.uid)
          .set({
        'email': userCredential.user?.email,
      });
      final name = userCredential.user!.displayName ?? 'Anonymous';
      String firstName = name;
      String lastName = '';
      if (name.contains(' ')) {
        firstName = name.substring(0, name.indexOf(' '));
        lastName = name.substring(name.indexOf(' ') + 1);
      }
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: firstName,
          lastName: lastName,
          lastSeen: DateTime.now().millisecondsSinceEpoch,
          id: userCredential.user!.uid, // UID from Firebase Authentication
          imageUrl: userCredential.user!.photoURL,
        ),
      );
    }

    return userCredential;
  }

  User? get currentUser => _firebaseAuth.currentUser;

  bool get isUserLoggedIn {
    return _firebaseAuth.currentUser != null;
  }
}
