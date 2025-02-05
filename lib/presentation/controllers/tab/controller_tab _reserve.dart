import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/models/reserve/lat_long_model.dart';
import 'dart:developer' as developer;

import 'package:weedool/models/reserve/model_center_list.dart';
import 'package:weedool/utils/location_util.dart';
import 'package:weedool/utils/logger.dart';

class TabReserveCtl {
  List<bool> selectArr = [];

  bool isLoading = false;
  NMarker? currentMarker;

  TabReserveCtl();

  Future<CenterListModel> requestCenterList() async {
    developer.log('aaa');
    late Map<String, dynamic> body;
    if (kDebugMode) {
      body = {'uuid': WDCommon().uuid, 'mode': true};
    } else {
      body = {'uuid': WDCommon().uuid, 'mode': false};
    }
    return await WDApis().requestCenterList(body);
  }

  final LocationUtil locationUtil = LocationUtil();

  void currentLocation() async {
    await locationUtil.getCurrentLocation().then((value) {
      WDCommon().setSelectedPosition(value.latitude, value.longitude);
    });
  }

  final ValueNotifier<bool> _isInitialized = ValueNotifier(false);

  void initCurrentMarker(NaverMapController nController, LatLongModel input) {
    if (_isInitialized.value == false) {
      nController.clearOverlays();
      currentMarker = NMarker(
          id: 'currentMarker',
          position: NLatLng(input.latitude, input.longitude),
          size: const Size(18, 24));
      if (currentMarker != null) {
        nController.addOverlay(currentMarker!);
      }
      _isInitialized.value = true;
    }
  }

  void setCurrentMarkerPosition(bool loading) {
    if (loading && currentMarker != null) {
      currentMarker
          ?.setPosition(NLatLng(WDCommon().latitude, WDCommon().longitude));
    }
  }
}
