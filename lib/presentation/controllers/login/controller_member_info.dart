import 'dart:developer' as developer;

import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/models/login/data_join.dart';
import 'package:weedool/models/login/model_login_res.dart';

class MemberInfoCtl {
  MemberInfoCtl();

  bool isLoading = false;

  int pageIndex = 0;

  String ninkName = '';
  String age = '';
  String sex = '';
  //청소년기준
  String breakfast = '';
  String instant = '';
  //성인기준
  String cigarette = '';
  String drink = '';
  //노인기준
  String exercise = '';
  String meet_person = '';

  String sleep1 = '';
  String sleep2 = '';

  Future<LoginResModel> requestJoin(JoinData joinData) async {
    developer.log('aaa');
    Map<String, dynamic> body = {};
    if (age == '10대') {
      body = {
        "nick_name": joinData.nick_name,
        "code_id": WDCommon().agency_code,
        "email": joinData.email,
        "name": joinData.name,
        "phone_number": joinData.phone_number,
        "password": joinData.password,
        "sex": sex,
        "age": age,
        "breakfast": breakfast,
        "instant": instant,
        "sleep_time": sleep1,
        "sleep_pattern": sleep2,
        "token": WDCommon().fcm_token
      };
    } else if (age == '65세 이상') {
      body = {
        "nick_name": joinData.nick_name,
        "code_id": WDCommon().agency_code,
        "email": joinData.email,
        "name": joinData.name,
        "phone_number": joinData.phone_number,
        "password": joinData.password,
        "sex": sex,
        "age": age,
        "exercise": exercise,
        "meet_person": meet_person,
        "sleep_time": sleep1,
        "sleep_pattern": sleep2,
        "token": WDCommon().fcm_token
      };
    } else {
      body = {
        "nick_name": joinData.nick_name,
        "code_id": WDCommon().agency_code,
        "email": joinData.email,
        "name": joinData.name,
        "phone_number": joinData.phone_number,
        "password": joinData.password,
        "sex": sex,
        "age": age,
        "drink": drink,
        "smoke": cigarette,
        "sleep_time": sleep1,
        "sleep_pattern": sleep2,
        "token": WDCommon().fcm_token
      };
    }
    developer.log('bbb');
    final response = await WDApis().requestJoin(body);

    developer.log('ccc');
    developer.log("response : $response");
    return response;
  }
}
