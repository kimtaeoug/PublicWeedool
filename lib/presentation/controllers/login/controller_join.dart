import 'package:flutter/material.dart';
import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/models/login/model_cert_phone.dart';
import 'package:weedool/models/model_base.dart';

import 'dart:developer' as developer;

class JoinCtl {
  static final JoinCtl join = JoinCtl._();

  factory JoinCtl() => join;

  JoinCtl._() {
    joinNameTFController.text = name;
    joinEmailTFController.text = email;
    joinPwdTFController.text = pwd;
    joinPwdCheckTFController.text = pwd2;
    joinPhoneTFController.text = phone;
    joinCertTFController.text = certNum;
    joinNicknameTFController.text = nickName;
  }

  void clearData() {
    joinNameTFController.clear();
    joinPhoneTFController.clear();
    joinCertTFController.clear();
    joinEmailTFController.clear();
    joinPwdTFController.clear();
    joinPwdCheckTFController.clear();
    joinNicknameTFController.clear();
    emailCheck = false;
    pwdStatus = false;
    pwdStatus2 = false;
    BtnEnabledArr =  [false, false, false, false, false, false, false];
    name = '';
    phone = '';
    email = '';
    pwd = '';
    pwd2 = '';
    nickName = '';
    pageIndex = 0;
  }
  //인증번호
  PhoneCertifyModel certifyPhone = PhoneCertifyModel(phone: '', certify: false);

  TextEditingController joinNameTFController = TextEditingController();
  TextEditingController joinPhoneTFController = TextEditingController();
  TextEditingController joinCertTFController = TextEditingController();
  TextEditingController joinEmailTFController = TextEditingController();
  TextEditingController joinPwdTFController = TextEditingController();
  TextEditingController joinPwdCheckTFController = TextEditingController();
  TextEditingController joinNicknameTFController = TextEditingController();

  bool isLoading = false;
  List<bool> BtnEnabledArr = [false, false, false, false, false, false, false];

  String name = '';
  String phone = '';
  String certNum = '';
  String email = '';
  String pwd = '';
  String pwd2 = '';
  bool pwdStatus = false;
  bool pwdStatus2 = false;
  String nickName = '';

  bool emailCheck = false;
  bool nickNameCheck = false;

  int pageIndex = 0;

  Future<BaseModel> requestCheckEmail(String email) async {
    developer.log('aaa');
    Map<String, String> body = {'email': email};
    developer.log('bbb');
    final response = await WDApis().requestCheckEmail(body);
    developer.log('ccc');
    developer.log("response : $response");
    return response;
  }

  Future<BaseModel> requestCheckNickname(String nickname) async {
    developer.log('aaa');
    Map<String, String> body = {'nickname': nickname};
    developer.log('bbb');
    final response = await WDApis().requestCheckNickname(body);

    developer.log('ccc');
    developer.log("response : $response");
    return response;
  }

  Future<CertPhoneModel> requestCertPhoneSend(String telephone) async {
    Map<String, String> body = {'telephone': telephone, 'type' : 'APP'};
    final response = await WDApis().requestCertPhoneSend(body);
    return response;
  }

  Future<CertPhoneModel> requestCertPhoneCheck(
      String telephone, String certNum) async {
    developer.log('aaa');
    Map<String, String> body = {
      'telephone': telephone,
      "certificationNumber": certNum,
      'type' : 'APP'
    };
    developer.log('bbb');
    final response = await WDApis().requestCertPhoneCheck(body);

    developer.log('ccc');
    developer.log("response : $response");
    return response;
  }
}
class PhoneCertifyModel{
  String phone;
  bool certify;
  PhoneCertifyModel({required this.phone, required this.certify});
}