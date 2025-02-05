import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/models/login/model_login_res.dart';
import 'dart:developer' as developer;

class LoginCtl {
  LoginCtl() {
    loginEmailTFController.text = txtEmail;
    loginPwdTFController.text = txtPwd;
  }

  bool isLoading = false;
  String txtEmail = '';
  String txtPwd = '';

  bool pwdStatus = false;

  TextEditingController loginEmailTFController = TextEditingController();
  TextEditingController loginPwdTFController = TextEditingController();

  Future<LoginResModel> requestLogin() async {
    developer.log('aaa');
    String? value = await FirebaseMessaging.instance.getToken();

    Map<String, dynamic> body = {
      'email': txtEmail,
      'password': txtPwd,
      'code_id': WDCommon().agency_code,
      'token': value ?? WDCommon().fcm_token
    };
    developer.log('bbb');
    final response = await WDApis().requestLogin(body);

    developer.log('ccc');
    developer.log("response : $response");
    return response;
  }
}
