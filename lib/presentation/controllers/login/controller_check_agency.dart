import 'package:flutter/material.dart';
import 'package:weedool/components/wd_apis.dart';
import 'dart:developer' as developer;

import 'package:weedool/models/model_base.dart';

class CheckAgencyCtl {
  CheckAgencyCtl() {
    codeTFController.text = txtAgency;
  }
  
  bool isLoading = false;
  String txtAgency = '';
  final TextEditingController codeTFController = TextEditingController();

  Future<BaseModel> requestCheckAgency() async {
    developer.log('aaa');
    Map<String, String> body = {'code_id': txtAgency};
    developer.log('bbb');
    final response = await WDApis().requestCheckAgency(body);

    developer.log('ccc');
    developer.log("response : $response");

    return response;
  }
}
