import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weedool/component/wb_search.dart';
import 'package:weedool/components/wd_colors.dart';

import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_text_style.dart';
import 'package:weedool/models/reserve/model_center_list.dart';
import 'package:weedool/utils/ga_util.dart';
import 'package:weedool/utils/location_util.dart';
import 'package:weedool/views/loading_page.dart';
import 'package:weedool/views/reserve/center_info.dart';
import 'package:weedool/views/reserve/search.dart';

import '../../controllers/tab/controller_tab _reserve.dart';

class TabReserveView extends StatefulWidget {
  const TabReserveView({Key? key}) : super(key: key);

  @override
  State<TabReserveView> createState() => _TabReserveState();
}

class _TabReserveState extends State<TabReserveView> {
  double height = 0;
  double width = 0;

  bool _popStatus = false;

  late CenterListModel centerListModel;

  List<NMarker> arrMarker = [];

  List<String> category = [];

  String _centerId = "";
  String _centerImageUrl =
      "https://weedool-web-back.s3.ap-northeast-2.amazonaws.com/test/main/monkey.png";
  String _centerName = "충남힐링상담센터";
  String _centerCategory = "심리";
  String _centerDistance = "1km";
  String _centerAddr = "서울시 송파구 방이동";

  // 마커관련
  TabReserveCtl tabReserveCtl = TabReserveCtl();
  bool onMarkerLoad = false;

  // NMarker? currentMarker;
  late NaverMapController nController;

  // final Location location = Location();
  final LocationUtil locationUtil = LocationUtil();
  void setLocation() async {
    locationUtil.startListeningLocation(_listener);
  }

  dynamic _listener(Position input){
    tabReserveCtl.currentLocation();
    if(mounted){
      tabReserveCtl.setCurrentMarkerPosition(onMarkerLoad);
    }
  }

  void addMarker(BuildContext context, NaverMapController nController,
      CenterListModel obj) async {
    nController.getCameraPosition().then((value) async {
      arrMarker.clear();

      for (int i = 0; i < obj.data!.length; i++) {
        const iconImage =
            NOverlayImage.fromAssetImage('assets/images/ic_marker_off.png');

        NMarker marker = NMarker(
            id: 'marker$i',
            position: NLatLng(double.parse(obj.data![i].latitude),
                double.parse(obj.data![i].longitude)),
            icon: iconImage,
            size: const Size(35, 35));

        // for(int i = 0; i < obj.data![i].category)

        arrMarker.add(marker);

        nController.addOverlay(marker);
      }

      for (int i = 0; i < arrMarker.length; i++) {
        arrMarker[i].setOnTapListener((overlay) {
          for (var element in arrMarker) {
            element.setIcon(const NOverlayImage.fromAssetImage(
                'assets/images/ic_marker_off.png'));
          }
          overlay.setIcon(const NOverlayImage.fromAssetImage(
              'assets/images/ic_marker_on.png'));
          final markerCameraUpdate = NCameraUpdate.withParams(
              target: NLatLng(
                  overlay.position.latitude, overlay.position.longitude),
              zoom: 16);
          nController.updateCamera(markerCameraUpdate);
          setState(() {
            _popStatus = true;
            _centerId = obj.data![i].center_id;
            _centerName = obj.data![i].center_name;
            _centerAddr = WDCommon().addrReplace(obj.data![i].location);
            if (obj.data![i].category!.isNotEmpty) {
              _centerCategory = obj.data![i].category![0];
            } else {
              _centerCategory = '';
            }
            _centerImageUrl =
                'https://weedool-web-back.s3.ap-northeast-2.amazonaws.com/${obj.data![i].center_img.main_img_path}';

            var distance = WDCommon().calculateDistance(
                WDCommon().latitude,
                WDCommon().longitude,
                double.parse(obj.data![i].latitude),
                double.parse(obj.data![i].longitude));
            _centerDistance = "${distance < 1 ? 1 : distance.toInt()}km";
          });
        });
      }
      // final cameraUpdate = NCameraUpdate.withParams(
      //     target: NLatLng(WDCommon().lat, WDCommon().lng), zoom: 8);
      // cameraUpdate.setAnimation(
      //     animation: NCameraAnimation.fly,
      //     duration: const Duration(seconds: 1));
      // nController.updateCamera(cameraUpdate);
    });
  }

  @override
  void initState() {
    GaUtil().trackScreen('ReservePage', input: {'uuid' : WDCommon().uuid});
    super.initState();
    setLocation();
  }

  @override
  Widget build(BuildContext context) {
    final Completer<NaverMapController> mapControllerCompleter = Completer();

    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Scaffold(
        body: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Stack(children: [
              ValueListenableBuilder(valueListenable: WDCommon().latLng, builder: (_, value2, child){
                return NaverMap(
                  options: NaverMapViewOptions(
                    indoorEnable: true, // 실내 맵 사용 가능 여부 설정
                    locationButtonEnable: false, // 위치 버튼 표시 여부 설정
                    consumeSymbolTapEvents: false, // 심볼 탭 이벤트 소비 여부 설정
                    initialCameraPosition: NCameraPosition(
                      target: NLatLng(value2.latitude, value2.longitude),
                      zoom: 14,
                    ),
                  ),
                  onMapReady: (controller) async {
                    // 지도 준비 완료 시 호출되는 콜백 함수
                    mapControllerCompleter
                        .complete(controller); // Completer에 지도 컨트롤러 완료 신호 전송
                    nController = controller;
                    setState(() {
                      tabReserveCtl.isLoading = true;
                    });
                    tabReserveCtl.requestCenterList().then((value) async {
                      tabReserveCtl.initCurrentMarker(nController, value2);
                      onMarkerLoad = true;
                      //지도 거꾸로 돌리는 원인
                      addMarker(context, nController, value);
                      centerListModel = value;
                      setState(() {
                        tabReserveCtl.isLoading = false;
                      });
                    });
                    if (WDCommon().selectedPosition != null) {
                      nController.updateCamera(NCameraUpdate.withParams(
                          target: NLatLng(WDCommon().selectedPosition!.dx,
                              WDCommon().selectedPosition!.dy),
                          zoom: 14)
                        ..setAnimation(
                            duration: const Duration(seconds: 1),
                            animation: NCameraAnimation.fly));
                      WDCommon().setSelectedPosition(null, null);
                    }
                  },
                );
              }),
              tabReserveCtl.isLoading
                  ? const LoadingPage(isLoading: true)
                  : Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 30),
                child: _bodyContents(),
              ),
            ])),
      ),
    );
  }

  Widget _bodyContents() {
    return SizedBox(
      height: height,
      // height: height - 196,
      width: width,
      child: Column(
        children: [
          WBSearch(
              width: width,
              function: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReserveSearchView(
                              centerListModel: centerListModel,
                            )));
              }),
          const Spacer(),
          _popStatus
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CenterInfoView(
                                  center_id: _centerId,
                                )));
                  },
                  child: Container(
                    width: width,
                    margin: const EdgeInsets.only(bottom: 72),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 26, vertical: 22),
                    decoration: const BoxDecoration(
                        color: WDColors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        border: Border(
                            top: BorderSide(
                                width: 1.0, color: Color(0xFFececec)))),
                    child: SizedBox(
                      width: width,
                      height: 122,
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              image: DecorationImage(
                                  // image: AssetImage(
                                  // 'assets/images/sample_center_img.png'),
                                  image: NetworkImage(_centerImageUrl),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(
                            width: 19,
                          ),
                          SizedBox(
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.5),
                                  child: Text(
                                      WDCommon()
                                          .replaceStringLength(_centerName, 18),
                                      textAlign: TextAlign.left,
                                      style: AppTextStyles.heading3(
                                          WDColors.black)),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        WDCommon().replaceStringLength(
                                            _centerCategory, 25),
                                        textAlign: TextAlign.left,
                                        style: AppTextStyles.body4(
                                            WDColors.black)),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/ic_center_distance.png',
                                            width: 7,
                                            height: 10,
                                            fit: BoxFit.contain),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(_centerDistance,
                                            textAlign: TextAlign.left,
                                            style: AppTextStyles.body6(
                                                const Color(0xFFA8A8A8))),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          width: 1,
                                          height: 12,
                                          decoration: const BoxDecoration(
                                              color: Color(0xFFA8A8A8)),
                                        ),
                                        Text(
                                            WDCommon().replaceStringLength(
                                                WDCommon().addrReplace(
                                                    WDCommon().addrReplace(
                                                        _centerAddr)),
                                                20),
                                            textAlign: TextAlign.left,
                                            style: AppTextStyles.body6(
                                                const Color(0xFFA8A8A8))),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3.5,
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
              : const SizedBox()
        ],
      ),
    );
  }
}
