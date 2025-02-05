import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/models/reserve/model_center_info.dart';
import 'package:weedool/models/reserve/model_center_list.dart';
import 'dart:developer' as developer;

import 'package:weedool/utils/logger.dart';

class CenterInfoCtl {



  final Completer<NaverMapController> mapControllerCompleter = Completer();
  late NaverMapController nController;

  CenterInfoCtl();

  bool isLoading = false;

  List<String> centerCategory = [
    '아동 심리 전문',
    '불안',
    '가족 심리 전문',
    '우울증 전문 상담의',
    'ADHD 전문 상담의'
  ];

  String centerLocation = '경기도 성남시 분당구 판교역로 166';

  int tabPosition = 0;

  Future<CenterInfoModel> requestCenterInfo(String center_id) async {
    Map<String, dynamic> body = {'center_id': center_id};
    final response = await WDApis().requestCenterInfo(body);
    return response;
  }

  void addMarker(BuildContext context, NaverMapController nController,double lat,double lng) async {
    nController.getCameraPosition().then((value) async {
      const iconImage =
            NOverlayImage.fromAssetImage('assets/images/ic_marker_on.png');

        NMarker marker = NMarker(
            id: 'marker',
            position: NLatLng(lat,lng),
            icon: iconImage,
            size: const Size(35, 35));


        nController.addOverlay(marker);
    });
  }

}
