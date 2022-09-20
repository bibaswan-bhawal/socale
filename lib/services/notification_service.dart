import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socale/firebase_options.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService().init();
  receivedChatMessage(message);

  print("Handling a background message: ${message.messageId}");
}

void receivedChatMessage(RemoteMessage message) async {
  if (flutterLocalNotificationsPlugin == null) {
    throw ("notification plugin has not been initialized yet");
  }

  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    "CHAT",
    "Chat messages",
    channelDescription: "Notifications for chat messages",
    importance: Importance.max,
    priority: Priority.max,
    channelShowBadge: true,
    enableVibration: true,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin!.show(
    (DateTime.now().microsecondsSinceEpoch / DateTime.now().millisecondsSinceEpoch).truncate(),
    "New Messages",
    message.data['message'],
    platformChannelSpecifics,
  );
}

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> requestNotificationPermission() async {
    if (Platform.isAndroid && flutterLocalNotificationsPlugin != null) {
      flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
    } else if (Platform.isIOS && flutterLocalNotificationsPlugin != null) {
      await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  void onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {
    print('old IOS');
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      print('notification payload: $payload');
    }
  }

  Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.getToken();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin?.initialize(initializationSettings, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      receivedChatMessage(message);

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
