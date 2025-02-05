import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_constants.dart';
import 'package:weedool/utils/device_info_util.dart';
import 'package:weedool/utils/ga_util.dart';
import 'package:weedool/utils/logger.dart';
import 'package:weedool/utils/package_util.dart';
import 'package:weedool/utils/permission_util.dart';
import 'package:weedool/utils/preference_util.dart';
import 'package:weedool/views/home.dart';
import 'package:weedool/views/login/check_agency.dart';
import 'package:weedool/views/splash/splash_animation.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashState();
}

class _SplashState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  final PermissionUtil permissionUtil = PermissionUtil();
  void requestLogin() async {
    PackageUtil().init();
    PreferenceUtil().init();
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? seenSearchCM = pref.getBool(SEEN_SEARCH_COACH_MARK);
    bool? seenActivityCM = pref.getBool(SEEN_ACTIVITY_COACH_MARK);
    if (seenSearchCM != null) {
      WDCommon().setSeenCoachMarkSearch(seenSearchCM);
    }
    if (seenActivityCM != null) {
      WDCommon().setSeenCoachMarkActivity(seenActivityCM);
    }
    DeviceInfoUtil().init();
    // bool notiPermission = false;
    // bool locationPermission = false;
    // await permissionUtil.checkNotiPermission().then((value)async{
    //   notiPermission = value;
    //   await PermissionUtil().checkLocation().then((value2){
    //     locationPermission = value2;
    //   });
    // });
    // // await PermissionUtil().checkNotiPermission().then((value)){
    // //
    // // };

    WDLog.e('hey!');
    permissionUtil.checkPermission();
    WDLog.e('hey!!');

    // bool notiPermission = await PermissionUtil().checkNotiPermission();
    // WDLog.e('notiPermission : $notiPermission');
    // bool locationPermission = await PermissionUtil().checkLocation();
    // if (locationPermission || notiPermission) {
    //   if (pref.getString('uuid') == '' || pref.getString('uuid') == null) {
    //     Future.delayed(Duration(milliseconds: Platform.isAndroid ? 100 : 500))
    //         .then((_) {
    //       Navigator.pushAndRemoveUntil(
    //           context,
    //           MaterialPageRoute(
    //               builder: (BuildContext context) => const CheckAgencyView()),
    //           (route) => false);
    //     });
    //   } else {
    //     WDCommon().uuid = pref.getString('uuid')!;
    //     Future.delayed(Duration(milliseconds: Platform.isAndroid ? 100 : 500))
    //         .then((_) {
    //       Navigator.pushAndRemoveUntil(
    //           context,
    //           MaterialPageRoute(
    //               builder: (BuildContext context) => const HomeView(
    //                     selectedIndex: 2,
    //                   )),
    //           (route) => false);
    //     });
    //   }
    // }
  }

  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2500));

  @override
  initState() {
    GaUtil().trackScreen('SplashPage', input: {'uuid': WDCommon().uuid});
    super.initState();
    _controller.forward().then((_) {
      requestLogin();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.noScaling),
        child: Scaffold(
          body: SizedBox(
            width: size.width,
            height: size.height,
            child: SplashAnimation(controller: _controller),
          ),
          backgroundColor: WDColors.mainColor,
        ));
  }
}
