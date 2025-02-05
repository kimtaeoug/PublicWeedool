import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/component/dialog.dart';
import 'package:weedool/models/activity/model_calendar_daily.dart';
import 'package:weedool/models/model_checkup.dart';
import 'package:weedool/models/reserve/lat_long_model.dart';
import 'package:weedool/models/tab/model_main.dart';
import 'package:weedool/utils/location_util.dart';
import 'package:weedool/utils/logger.dart';
import 'package:weedool/utils/permission_util.dart';
import 'dart:developer' as developer;

import 'package:weedool/views/popup/pop_mood_check.dart';
import 'package:weedool/views/test/intake_test_page.dart';

class TabHomeCtl {
  static final TabHomeCtl _instance = TabHomeCtl._();

  TabHomeCtl._();

  factory TabHomeCtl() => _instance;
  bool isLoading = false;

  final LocationUtil locationUtil = LocationUtil();
  final PermissionUtil _permissionUtil = PermissionUtil();

  final ValueNotifier<bool> loading = ValueNotifier(false);

  Future<MainModel> requestMain() async {
    loading.value = true;
    String lat = '';
    String lng = '';
    if (_permissionUtil.location) {
      LatLongModel position = (await locationUtil.getCurrentLocation());
      lat = (position.latitude ?? 37.5665851).toString();
      lng = (position.longitude ?? 126.9782038).toString();
    } else {
      lat = WDCommon().latitude.toString();
      lng = WDCommon().longitude.toString();
    }
    Map<String, dynamic> body = {
      'uuid': WDCommon().uuid,
      'latitude': lat,
      'longitude': lng
    };
    final response = await WDApis().requestMain(body);
    return response;
  }

  Future<Activity> requestTodayActivity(MainModel mainModel) async {
    DailyCalendarModel response = await requestDaily(DateTime.now());
    return findRightActivity(response, mainModel);
  }

  Future<DailyCalendarModel> requestDaily(DateTime datetime) async {
    Map<String, dynamic> body = {
      'uuid': WDCommon().uuid,
      'date': DateFormat('yyyy-MM-dd').format(datetime)
    };
    final response = await WDApis().requestDailyCalendar(body);
    return response;
  }

  Activity findRightActivity(DailyCalendarModel input, MainModel mainModel) {
    List<Activity> dailyList = input.data.activity_list
        .where((e) => e.activity_class != 'Weekly')
        .toList();
    return dailyList
        .where((e) => e.activity_id == mainModel.data.ba_today!.activity_id)
        .first;
  }

  void setLocation() async {
    await locationUtil.getCurrentLocation().then((value) {
      WDCommon().latLng.value = LatLongModel(value.latitude, value.longitude);
    });
  }

  void showPopDaily(BuildContext context,
      {required Function() function, bool showMood = true}) async {
    WDDialog.twoBtnImgDialog(
        context,
        '${WDCommon().nickName}님, 요새\n잠은 잘 자고 있나요?',
        '아니요',
        '네',
        (dialogContext) {
          function.call();
          Navigator.pop(dialogContext);
          if (showMood) {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false, // set to false
                pageBuilder: (_, __, ___) => const MoodCheckView(),
              ),
            );
          }
        },
        (dialogContext) {
          function.call();
          Navigator.pop(dialogContext);
          if (showMood) {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false, // set to false
                pageBuilder: (_, __, ___) => const MoodCheckView(),
              ),
            );
          }
        },
        'assets/images/ic_dlg_letter.png',
        backFunction: (dialogContext) {
          //   function.call();
          //   Navigator.pop(dialogContext);
          //   if(showMood){
          //     Navigator.of(context).push(
          //       PageRouteBuilder(
          //         opaque: false, // set to false
          //         pageBuilder: (_, __, ___) => const MoodCheckView(),
          //       ),
          //     );
          //   }
          // }
        });
  }

  void showPopTest(BuildContext context, Function() leftFunction) async {
    WDDialog.twoBtnDialog(context, '기본 문진을 아직\n완료하지 않으셨어요!', '다음에 할래요', '검사하기',
        (dialogContext) {
      Navigator.pop(dialogContext);
      leftFunction.call();
    }, (dialogContext) {
      Navigator.pop(dialogContext);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const IntakeTestPage(category: 'INTAKE')),
      );
    }, subTitle: '검사를 완료해주세요', backFunction: (dialogContext) {}
        // backFunction: (dialogContext) {
        //   Navigator.pop(dialogContext);
        //   leftFunction.call();
        // }
        );
  }

  final ValueNotifier<CheckupModel?> checkUpModel = ValueNotifier(null);
}
