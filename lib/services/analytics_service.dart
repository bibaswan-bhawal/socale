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

  Future<void> recordiChatSessionLength(int sessionLength) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('ChatSessionLength');

    // You can also add the properties one by one like the following
    event.properties.addIntProperty('sessionLength', sessionLength);
    event.properties.addStringProperty('userId', userId);

    await Amplify.Analytics.recordEvent(event: event);
  }

  Future<void> overallSessionLength(int sessionLength) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('OverallSessionLength');

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

  // Every time a user opens the app, we will use this to count MAU, DAU, WAU, Active Times and what not.
  Future<void> recordUserSignIn() async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('UserSignIn');
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // You can also add the properties one by one like the following
    event.properties.addStringProperty('userId', userId);
    event.properties.addIntProperty('timestamp', timestamp);

    await Amplify.Analytics.recordEvent(event: event);
  }

  // Should be placed in the chat to count external links opened in each session, should push default to zero
  Future<void> openedLinks(int openedLinks) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('OpenedLinks');

    // You can also add the properties one by one like the following
    event.properties.addIntProperty('openedLinks', openedLinks);
    event.properties.addStringProperty('userId', userId);

    await Amplify.Analytics.recordEvent(event: event);
  }

  Future<void> matchAccepted(double strengthScore, String matchType) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('MatchAccepted');

    // You can also add the properties one by one like the following
    event.properties.addDoubleProperty('strengthScore', strengthScore);
    event.properties.addStringProperty('matchType', matchType);
    event.properties.addStringProperty('userId', userId);

    await Amplify.Analytics.recordEvent(event: event);
  }

  // Substract when room was created to the time when a person clicked on share profile
  Future<void> matchUnlockTime(double timeTaken) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('MatchUnlockTime');

    // You can also add the properties one by one like the following
    event.properties.addDoubleProperty('timeTaken', timeTaken);
    event.properties.addStringProperty('userId', userId);

    await Amplify.Analytics.recordEvent(event: event);
  }

  Future<void> errorRecorded(String error) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('ErrorRecorded');

    // You can also add the properties one by one like the following
    event.properties.addStringProperty('error', error);
    event.properties.addStringProperty('userId', userId);

    await Amplify.Analytics.recordEvent(event: event);
  }

  Future<void> editProfileTime(double timeTaken) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('EditProfileTime');

    // You can also add the properties one by one like the following
    event.properties.addDoubleProperty('timeTaken', timeTaken);
    event.properties.addStringProperty('userId', userId);

    await Amplify.Analytics.recordEvent(event: event);
  }

  Future<void> settingsTime(double timeTaken) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final event = AnalyticsEvent('SettingsTime');

    // You can also add the properties one by one like the following
    event.properties.addDoubleProperty('timeTaken', timeTaken);
    event.properties.addStringProperty('userId', userId);

    await Amplify.Analytics.recordEvent(event: event);
  }
}

final analyticsService = AnalyticsService();
