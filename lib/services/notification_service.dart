import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socale/firebase_options.dart';
import 'package:socale/services/native_methods_service.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

bool isFlutterLocalNotificationsInitialized = false;

// Handle notifications that arrive in the background for android and IOS, does not get called if app is terminated in IOS.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) print('Handling a background message ${message.data}');

  if (Platform.isIOS) {
    deleteNotificationsInIosCoreData();
  }

  // Got notification --> parse message --> call functions to deal with data
}

@pragma('vm:entry-point')
Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) return;

  channel = const AndroidNotificationChannel(
    'message_notification_channel',
    'Messages',
    description: 'Receive notifications when people message you.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: false, badge: false, sound: false);

  isFlutterLocalNotificationsInitialized = true;
}

@pragma('vm:entry-point')
void showFlutterNotification(RemoteMessage message, AuthorizationStatus permissionAuthStatus) {
  if (permissionAuthStatus != AuthorizationStatus.authorized) return;

  RemoteNotification? notification = message.notification;
  AndroidNotification? androidNotification = notification?.android;

  // Only show notification if received in foreground on android
  if (notification != null && androidNotification != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background',
        ),
        iOS: const DarwinNotificationDetails(
          sound: 'default',
          presentSound: true,
          presentAlert: true,
        ),
      ),
    );
  }
}

class NotificationService {
  static String? deviceToken;

  late FirebaseMessaging fcmMessaging;
  late NotificationSettings notificationSettings;
  AuthorizationStatus permissionAuthStatus = AuthorizationStatus.notDetermined;
  NotificationService();

  Future<void> initNotificationService() async {
    fcmMessaging = FirebaseMessaging.instance;

    await requestPermissions();

    deviceToken = await FirebaseMessaging.instance.getToken();
    print(deviceToken);

    FirebaseMessaging.onMessage.listen(onMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageReceived);
  }

  void onMessageReceived(RemoteMessage message) {
    if (kDebugMode) print("message received in foreground: ${message.data}");

    showFlutterNotification(message, permissionAuthStatus);

    if (Platform.isIOS) {
      deleteNotificationsInIosCoreData();
    }
  }

  Future<void> requestPermissions() async {
    notificationSettings = await fcmMessaging.requestPermission(alert: true, badge: true, sound: true);
    permissionAuthStatus = notificationSettings.authorizationStatus;
    if (kDebugMode) print("Notification permission status: $permissionAuthStatus");
  }

  static void onMessageOpenedApp(RemoteMessage message) {
    if (kDebugMode) print('Notification open app and contained data: ${message.data}');
    // parse --> route to correct page
  }

  static Future<void> initBackgroundNotificationService() async {
    // Init Firebase and FCM
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Check for notifications that came in while app was terminated
    if (Platform.isIOS) getNotificationsFromIosCoreData();

    // init local notifications
    if (Platform.isAndroid || Platform.isIOS) await setupFlutterNotifications();

    RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (remoteMessage != null) {
      onMessageOpenedApp(remoteMessage);
    }
  }
}
