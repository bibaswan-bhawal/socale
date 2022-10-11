import 'dart:async';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/firebase_options.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/services/fetch_service.dart';
import 'package:socale/utils/providers/providers.dart';

class NotificationService {
  late WidgetRef widgetRef;

  NotificationService setWidgetRef(WidgetRef ref){
    widgetRef = ref;

    return this;
  }

  Future<void> initFirebaseMessaging() async {
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
      User? user = await fetchService.fetchUserById(userId);

      if(user == null){
        throw(Exception("failed to get user"));
      }

      User newUser = user.copyWith(notificationToken: deviceToken);
      await widgetRef.read(userAsyncController.notifier).changeUserValue(newUser);
    } catch (e) {
      print("Device token could not be uploaded. error: $e");
    }
  }

  void init() async {
    await initFirebaseMessaging();
  }
}
