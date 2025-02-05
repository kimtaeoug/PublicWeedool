import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weedool/component/dialog.dart';
import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/models/model_base.dart';
import 'package:weedool/utils/preference_util.dart';
import 'package:weedool/views/login/check_agency.dart';
import 'dart:developer' as developer;

import 'package:weedool/views/popup/pop_base.dart';

class MypageCtl {
  MypageCtl();

  bool isLoading = false;

  Future<BaseModel> requestResign() async {
    developer.log('aaa');
    Map<String, dynamic> body = {'uuid': WDCommon().uuid};
    developer.log('bbb');
    final response = await WDApis().requestResign(body);
    developer.log('ccc');
    developer.log("response : $response");
    return response;
  }

  void requestLogout(Function() function) async {
    _preferenceUtil.setBeforeUUID(WDCommon().uuid);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('uuid', '');
    function.call();
    // pref.setString('uuid', '').then(
    //   (value) {
    //     exit(0);
    //   },
    // );
  }

  final PreferenceUtil _preferenceUtil = PreferenceUtil();
  void showPopLogout(BuildContext context) async {
    WDDialog.twoBtnDialog(
        context,
        '로그아웃',
        subTitle: '현재 계정을 로그아웃할까요?',
        '취소',
        '확인', (dialogContext) {
      Navigator.pop(dialogContext);
    }, (dialogContext) {
      Navigator.pop(dialogContext);
      requestLogout(() {
        _preferenceUtil.setCheckSleep(false);
        _preferenceUtil.setCheckMood(false);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const CheckAgencyView()),
            (route) => false);
      });
    });
  }

  void showPopResign(BuildContext context, Function function) async {
    WDDialog.twoBtnDialog(context, '회원탈퇴', '취소', '확인', (dialogContext) {
      Navigator.pop(dialogContext);
    }, (dialogContext) {
      Navigator.pop(dialogContext);
      requestResign().then((value) async {
        if (value.message == 'ok') {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString('uuid', '').then(
            (value) {
              function.call();
            },
          );
        } else {
          WDCommon().toast(context, value.message, isError: true);
        }
      });
    }, subTitle: '현재 이용중인 서비스를\n해지하시겠습니까?');
  }
}
