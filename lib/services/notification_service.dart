import 'dart:async';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socale/firebase_options.dart';
import 'package:socale/services/fetch_service.dart';
import 'package:socale/services/update_service.dart';

import '../models/ModelProvider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream = StreamController<ReceivedNotification>.broadcast();
final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();
const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');
const String portName = 'notification_send_port';
String? selectedNotificationPayload;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService().init();
  receivedChatMessage(message);

  print("Notifications: Handling a background message: ${message.messageId}");
}

void receivedChatMessage(RemoteMessage message) async {
  print("Notifications: Message UI Handler: ${message.messageId}");

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
    message.data['message'],
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
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: true,
          );
    }
  }

  void onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {
    print('old IOS');
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    selectNotificationStream.add(notificationResponse.payload);
  }

  updateDeviceToken() async {
    print(await FirebaseMessaging.instance.getToken());

    try {
      print("uploading token");
      final userId = (await Amplify.Auth.getCurrentUser()).userId;
      final user = await fetchService.fetchUserById(userId);

      User updatedUser = user.copyWith(notificationToken: await FirebaseMessaging.instance.getToken());
      await updateService.updateUser(updatedUser);
    } catch (e) {
      print("could not get current user");
    }
  }

  Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.instance.requestPermission();

    await updateDeviceToken();

    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin?.initialize(initializationSettings, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Notifications: Got a message whilst in the foreground!');
      receivedChatMessage(message);
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
