import 'package:amplify_flutter/amplify_flutter.dart';

class AnalyticsService {
  Future<void> recordOnboardingTime(int timeTaken) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('PasswordReset');

    // You can also add the properties one by one like the following
    event.properties.addIntProperty('onboardingTime', timeTaken);
    event.properties.addStringProperty('userId', userId);

    await Amplify.Analytics.recordEvent(event: event);
  }
}

final analyticsService = AnalyticsService();
