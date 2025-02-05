import 'dart:async';

import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/models/chart/model_chart_dmsls.dart';
import 'dart:developer' as developer;
class ChartDmslsCtl {
  ChartDmslsCtl();

  bool isLoading = false;

  Future<ChartDmslsModel> requestChartDmsls() async {
    developer.log('aaa');
    Map<String, dynamic> body = {'uuid': WDCommon().uuid};
    developer.log('bbb');
    final response = await WDApis().requestChartDmsls(body);
    developer.log('ccc');
    developer.log("response : $response");
    return response;
  }
}
//2024-06-21 11:30:39

class DmslsChart {
  DmslsChart(this.round, this.total_score, this.date);

  final int round;
  final int total_score;
  final String date;
}
