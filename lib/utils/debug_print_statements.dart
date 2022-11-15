import 'package:flutter/foundation.dart';

void printRunTime(DateTime startTime, String text) {
  if (kDebugMode) {
    print("[FEATURE RUN TIME]: $text ran in: ${DateTime.now().difference(startTime).inMilliseconds}");
  }
}
