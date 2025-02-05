import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/models/reserve/model_center_info.dart';
import 'dart:developer' as developer;

class SearchCtl {




  SearchCtl(){
    myController.text = searchStr;
  }

  bool isLoading = false;

  int tabPosition = 0;

  String searchStr = '';
  TextEditingController myController = TextEditingController();

  List<String> strCategory = [];

  List<String> selectedSearchStr = [];

  bool checkSelected(String name) => selectedSearchStr.contains(name);

}
