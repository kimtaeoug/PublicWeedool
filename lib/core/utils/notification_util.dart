import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';

import 'logger.dart';

@pragma('vm:entry-point')
class NotificationUtil {
  @pragma('vm:entry-point')
  static void initFirebase() async {
    String? value = await FirebaseMessaging.instance.getToken();
    WDCommon().fcm_token = value!;
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    if (!kIsWeb) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  static var initializationSettingsAndroid =
      const AndroidInitializationSettings("@drawable/ic_notification");
  static var initializationSettingsIOS = const DarwinInitializationSettings();

  static FirebaseMessaging instance = FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  static void initFirebaseMessaging() async {
    instance.getInitialMessage().then((value) {
      if (value != null) {
        if (value.data.containsKey('app_route')) {
          WDLog.e('3message : ${value.data}');

        }
      }
    });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {
      String? routeFromMessage = details.payload;
      if (routeFromMessage != null) {
        if (details.payload != null) {
          WDLog.e('1message : ${details}');
          //payload action이 있으면
        }
      }
    });
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);
    instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      String? title = notification?.title;
      String? body = notification?.body;
      String? routeFromMessage = message.data["app_route"];
      if (notification?.android != null && title != null && body != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            title,
            body,
            NotificationDetails(
                android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@drawable/ic_launcher',
              color: WDColors.primaryColor,
            )),
            payload: routeFromMessage);
      }
      Map<String, dynamic> data = message.data;
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }
}

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  print('app_route : ${message}');
  WDLog.e('2message : ${message}');

}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
