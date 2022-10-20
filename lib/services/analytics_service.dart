import 'package:amplify_flutter/amplify_flutter.dart';

class AnalyticsService {
  Future<void> recordOnboardingTime(int timeTaken) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('OnboardingTime');

    // You can also add the properties one by one like the following
    event.properties.addIntProperty('onboardingTime', timeTaken);
    event.properties.addStringProperty('userId', userId);

    await Amplify.Analytics.recordEvent(event: event);
  }

  Future<void> recordChatSessionLength(int sessionLength) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('ChatSessionLength');

    // You can also add the properties one by one like the following
    event.properties.addIntProperty('sessionLength', sessionLength);
    event.properties.addStringProperty('userId', userId);

    await Amplify.Analytics.recordEvent(event: event);
  }

  Future<void> screensPerSession(int screensPerSession) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('ScreensPerSession');

    // You can also add the properties one by one like the following
    event.properties.addIntProperty('screensPerSession', screensPerSession);
    event.properties.addStringProperty('userId', userId);

    await Amplify.Analytics.recordEvent(event: event);
  }

  // // Substract when room was created to the time when a person clicked on share profile
  // Future<void> matchUnlockTime(double timeTaken) async {
  //   final userId = (await Amplify.Auth.getCurrentUser()).userId;
  //   final event = AnalyticsEvent('MatchUnlockTime');

  //   // You can also add the properties one by one like the following
  //   event.properties.addDoubleProperty('timeTaken', timeTaken);
  //   event.properties.addStringProperty('userId', userId);

  //   await Amplify.Analytics.recordEvent(event: event);
  // }

  Future<void> editProfileTime(int timeTaken) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('EditProfileTime');

    // You can also add the properties one by one like the following
    event.properties.addIntProperty('timeTaken', timeTaken);
    event.properties.addStringProperty('userId', userId);

    await Amplify.Analytics.recordEvent(event: event);
  }

  Future<void> settingsTime(int timeTaken) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('SettingsTime');

    // You can also add the properties one by one like the following
    event.properties.addIntProperty('timeTaken', timeTaken);
    event.properties.addStringProperty('userId', userId);

    await Amplify.Analytics.recordEvent(event: event);
  }
}

final analyticsService = AnalyticsService();
