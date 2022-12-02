import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/main_app.dart';
import 'package:socale/services/notification_service.dart';

late DateTime appStartTime;

void main() async {
  appStartTime = DateTime.now();

  WidgetsFlutterBinding.ensureInitialized();

  // await NotificationService.initBackgroundNotificationService();

  runApp(const ProviderScope(child: MainApp()));
}
