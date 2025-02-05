import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/models/reserve/model_center_info.dart';
import 'package:weedool/models/reserve/model_center_list.dart';
import 'dart:developer' as developer;

import 'package:weedool/models/reserve/model_counselor_info.dart';

class CounselorInfoCtl {

  CounselorInfoCtl();

  bool isLoading = false;


  Future<CounselorInfoModel> requestCounselorInfo(String center_id,String counselor_id) async {
    developer.log('aaa');
    Map<String, dynamic> body = {'center_id': center_id,'counselor_id':counselor_id};
    developer.log('bbb');
    final response = await WDApis().requestCounselorInfo(body);
    developer.log('ccc');
    developer.log("response : $response");
    return response;
  }


}
