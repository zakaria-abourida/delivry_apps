import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';

class FirebaseAnalyticsService {
  static FirebaseAnalytics _analytics = FirebaseAnalytics();

  static FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  static Future logScreens({@required String name}) async {
    await _analytics.setCurrentScreen(screenName: name);
  }

  static Future logLogin() async {
    await _analytics.logLogin();
  }
}
