import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  Future<void> init() async {
    await FirebaseMessaging.instance.getToken();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin!.initialize(initializationSettings, onSelectNotification: selectNotification);

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

  Future selectNotification(String? payload) async {
    //Handle notification tapped logic here
  }
}
