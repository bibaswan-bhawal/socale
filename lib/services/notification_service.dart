import 'dart:async';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:socale/firebase_options.dart';
import 'package:socale/models/ModelProvider.dart';

class NotificationService {
  Future<void> initFirebaseMessaging() async {
    print("Notification: Initializing Firebase Messaging.");

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseMessaging.instance.requestPermission();
    await uploadDeviceToken();
  }

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> uploadDeviceToken() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    final deviceToken = await FirebaseMessaging.instance.getToken();

    try {
      String? userId = (await Amplify.Auth.getCurrentUser()).userId;

      final request = ModelQueries.get(User.classType, userId);
      final response = await Amplify.API.query(request: request).response;


      User? user = response.data;

      if(user == null){
        throw(Exception("could not get user"));
      }

      User newUser = user.copyWith(notificationToken: deviceToken);
      await Amplify.DataStore.save(newUser);

      print("Saved device token");
    } catch (e) {
      print("Device token could not be uploaded. error: $e");
    }
  }

  void init() async {
    await initFirebaseMessaging();
  }
}
