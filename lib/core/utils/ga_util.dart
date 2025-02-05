import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class GaUtil {
  static final GaUtil _instance = GaUtil._();

  factory GaUtil() => _instance;

  GaUtil._();

  late final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;

  ///
  /// 화면 Tracking
  ///
  void trackScreen(String screenName, {dynamic input}) async {
    if (!kDebugMode) {
      try {
        await _firebaseAnalytics.logScreenView(
            screenName: screenName, parameters: input);
      } catch (e, s) {
        await FirebaseCrashlytics.instance
            .recordError(e, s, reason: 'trackScreen\ninput : $input');
      }
    }
  }

  ///
  /// 화면 Event Tracking
  ///
  void trackEvent(String eventName, {Map<String, Object>? parameter}) async {
    if (!kDebugMode) {
      try {
        await _firebaseAnalytics.logEvent(
            name: eventName, parameters: parameter);
      } catch (e, s) {
        await FirebaseCrashlytics.instance
            .recordError(e, s, reason: 'trackEvent\ninput : $parameter');
      }
    }
  }
}
