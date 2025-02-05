import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weedool/components/wd_constants.dart';
import 'package:weedool/components/wd_themes.dart';
import 'package:weedool/utils/img_util.dart';
import 'package:weedool/utils/network_observer_util.dart';
import 'package:weedool/utils/notification_util.dart';

import 'package:weedool/views/splash.dart';
Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    initializeDateFormatting('ko', null);
    NotificationUtil.initFirebase();
    _nMapInitialize();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    NetworkObserverUtil().init();
    runApp(const MyApp());
  }, (error, stack) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance
          .recordError(error, stack, reason: 'Error Detected At RunZoneGuard');
    }
  });
}

Future<void> _nMapInitialize() async {
  await NaverMapSdk.instance.initialize(
      clientId: nMapClientId, onAuthFailed: (e) => print("네이버맵 인증오류 : $e"));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    NotificationUtil.initFirebaseMessaging();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ImgUtil.precacheImageFromAsset(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('ko', 'KR'),
        supportedLocales: const [
          Locale('ko', 'KR'),
        ],
        theme: WDThemes.lightTheme,
        home: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: const SplashView())
    );
  }
}
