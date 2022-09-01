import 'package:amplify_flutter/amplify_flutter.dart';

class AuthAnalytics {
  Future<void> recordUserSignIn() async {
    final event = AnalyticsEvent('User Signed In');
    event.properties.addBoolProperty('userSignIn', true);
    await Amplify.Analytics.recordEvent(event: event);
  }
}

final authAnalytics = AuthAnalytics();
