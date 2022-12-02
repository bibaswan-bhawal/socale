import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const platform = MethodChannel('com.socale.socale/ios');

Future<void> getNotificationsFromIosCoreData() async {
  List notifications;

  try {
    notifications = await platform.invokeMethod('getNotifications');
    await deleteNotificationsInIosCoreData();
  } on PlatformException catch (e) {
    throw ("Failed to get notifications: '${e.message}'.");
  }

  if (kDebugMode) print("Got list of notification data from IOS: $notifications");
}

Future<void> deleteNotificationsInIosCoreData() async {
  bool isSuccess;

  try {
    isSuccess = await platform.invokeMethod('deleteNotifications');
  } on PlatformException catch (e) {
    throw ("Failed to get delete notifications: '${e.message}'.");
  }

  if (kDebugMode) print("deleted notification storage: $isSuccess");
}
