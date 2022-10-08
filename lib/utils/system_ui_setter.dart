import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setSystemUILight() {
  if (Platform.isIOS) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  } else if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}

void setSystemUIDark() {
  if (Platform.isIOS) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  } else if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
