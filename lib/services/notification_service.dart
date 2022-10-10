import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:socale/firebase_options.dart';
import 'package:socale/models/ModelProvider.dart';

class NotificationService {
  Future<void> initFirebaseMessaging() async {
    print("Notification: Initializing Firebase Messaging.");

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseMessaging.instance.requestPermission();
    await uploadDeviceToken();
  }

  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> uploadDeviceToken() async {
    final deviceToken = await FirebaseMessaging.instance.getToken();

    try {
      String? userId = (await Amplify.Auth.getCurrentUser()).userId;
      User user = (await Amplify.DataStore.query(User.classType, where: User.ID.eq(userId))).first;

      await Amplify.DataStore.save(user.copyWith(notificationToken: deviceToken));
    } catch (e) {
      print("Device token could not be uploaded.");
    }
  }

  void init() async {
    await initFirebaseMessaging();
  }
}
