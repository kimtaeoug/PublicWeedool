import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/models/activity/model_activity_add.dart';
import 'package:weedool/models/activity/model_calendar_daily.dart';
import 'package:weedool/models/model_base.dart';
import 'package:weedool/utils/logger.dart';

class ActivityController {
  static final ActivityController _instance = ActivityController._();

  ActivityController._();

  factory ActivityController() => _instance;

  final WDCommon _wdCommon = WDCommon();
  final WDApis _api = WDApis();

  // Future<List<DateTime>> _requestMonth(String month) async {
  //   // Map<String, dynamic> body = {'uuid': _wdCommon.uuid, 'month': month};
  //   // final response = await _api.requestMonthCalendar(body);
  //   //
  //   // List<DateTime> list = [];
  //   //
  //   // specialDates = [];
  //   // for (int i = 0; i < response.data.history.length; i++) {
  //   //   if (response.data.history[i].progress == 1.0) {
  //   //     list.add(DateTime.tryParse(response.data.history[i].date)!);
  //   //   }
  //   // }
  //   //
  //   // developer.log("specialDates : $specialDates");
  //   //
  //   // _loading.value = false;
  //   return list;
  // }

  Future<DailyCalendarModel> requestDaily(DateTime datetime) async {
    WDLog.e('uuid : ${_wdCommon.uuid}');
    final response = await _api.requestDailyCalendar({
      'uuid': _wdCommon.uuid,
      'date': DateFormat('yyyy-MM-dd').format(datetime)
    });
    WDLog.e('response : ${response.data.toJson()}');
    return response;
  }

  final ValueNotifier<Offset> closeOffset = ValueNotifier(Offset.zero);
  final ValueNotifier<Offset> headerOffset = ValueNotifier(Offset.zero);
  final ValueNotifier<Offset> btnOffset = ValueNotifier(Offset.zero);
  final ValueNotifier<Offset> timeSlotOffset = ValueNotifier(Offset.zero);
  final ValueNotifier<Offset> dailyOffset = ValueNotifier(Offset.zero);

  ///
  /// ActivityList
  ///
  Future<List<AddActivity>> requestAddActivityList(
      {String type = 'daily'}) async {
    return (await _api.requestActivityList(WDCommon().uuid, type: type))
        .data
        .items;
  }

  ///
  /// AddActivity
  ///
  Future<BaseModel> requestAddActivity(String activity_id,
      {String category = 'DMSLS'}) async {
    WDLog.e('uuid : ${WDCommon().uuid}');
    return await _api.requestAddActivity(
        WDCommon().uuid, category, activity_id);
  }
  //
}
