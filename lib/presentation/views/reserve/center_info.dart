import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:lottie/lottie.dart';
import 'package:weedool/component/wd_btn.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_text_style.dart';
import 'package:weedool/controllers/reserve/controller_center_info.dart';
import 'package:weedool/models/reserve/model_center_info.dart';
import 'package:weedool/utils/ga_util.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/views/loading_page.dart';
import 'package:weedool/views/reserve/center_img_slider.dart';
import 'package:weedool/views/reserve/counselor_info.dart';

class CenterInfoView extends StatefulWidget {
  final String center_id;

  const CenterInfoView({Key? key, required this.center_id}) : super(key: key);

  @override
  State<CenterInfoView> createState() => _CenterInfoState();
}

class _CenterInfoState extends State<CenterInfoView> {
  double height = 0;
  double width = 0;

  CenterInfoCtl centerInfoCtl = CenterInfoCtl();

  late Future<CenterInfoModel> _centerInfoModel;

  final ValueNotifier<CenterInfoModel?> _centerModel = ValueNotifier(null);

  @override
  void initState() {
    GaUtil().trackScreen('CenterInfoPage',
        input: {'uuid': WDCommon().uuid, 'center_id': widget.center_id});
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!centerInfoCtl.isLoading) {
        setState(() {
          centerInfoCtl.isLoading = true;
        });
      }
      CenterInfoModel response =
          await centerInfoCtl.requestCenterInfo(widget.center_id);
      setState(() {
        _centerModel.value = response;
        centerInfoCtl.isLoading = false;
      });
      //
      // _centerInfoModel =
      //     centerInfoCtl.requestCenterInfo(widget.center_id).then((value) async {
      //       setState(() {
      //         centerInfoCtl.isLoading = false;
      //       });
      //       return value;
      //     });
    });
  }

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;
    return Scaffold(
        body: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: Stack(children: [
              ValueListenableBuilder(
                  valueListenable: _centerModel,
                  builder: (_, value, child) {
                    if (value != null) {
                      return _bodyContents(value);
                    } else {
                      return Container();
                    }
                  }),
              LoadingPage(isLoading: centerInfoCtl.isLoading)
            ])));
  }

  Widget _bodyContents(CenterInfoModel centerInfoModel) {
    return SizedBox(
        width: width,
        height: height,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              CenterImgSlider(
                  centerImg: centerInfoModel.data.center_info!.center_img),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                        centerInfoModel.data.center_info!.center_name,
                        textAlign: TextAlign.left,
                        style: AppTextStyles.heading3(WDColors.black),
                        maxLines: null,
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/ic_center_tel.png',
                              width: 16, height: 16, fit: BoxFit.contain),
                          GestureDetector(
                            onTap: () {
                              WDCommon().dialNumber(
                                  centerInfoModel.data.center_info!.center_tel);
                            },
                            child: Text(
                                WDCommon().replaceStringLength(
                                    centerInfoModel
                                        .data.center_info!.center_tel,
                                    15),
                                textAlign: TextAlign.center,
                                style:
                                    AppTextStyles.body6(WDColors.alternative)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisSize: MainAxisSize.max,
                //   children: [
                //     Expanded(
                //         child: GestureDetector(
                //       onTap: () {
                //         setState(() {
                //           centerInfoCtl.tabPosition = 0;
                //         });
                //       },
                //       child: Container(
                //         padding: const EdgeInsets.symmetric(vertical: 12),
                //         child: Center(
                //           child: Text('상담센터 정보',
                //               style: AppTextStyles.body4(
                //                       centerInfoCtl.tabPosition == 0
                //                           ? const Color(0xFF1983D0)
                //                           : const Color(0xFFA8A8A8))
                //                   .copyWith(
                //                       fontWeight: centerInfoCtl.tabPosition == 0
                //                           ? FontWeight.w600
                //                           : FontWeight.w500)),
                //         ),
                //       ),
                //     )),
                //     Expanded(
                //         child: GestureDetector(
                //       onTap: () {
                //         setState(() {
                //           centerInfoCtl.tabPosition = 1;
                //         });
                //       },
                //       child: Container(
                //         padding: const EdgeInsets.symmetric(vertical: 12),
                //         child: Center(
                //           child: Text('상담사 정보',
                //               style: AppTextStyles.body4(
                //                       centerInfoCtl.tabPosition == 1
                //                           ? const Color(0xFF1983D0)
                //                           : const Color(0xFFA8A8A8))
                //                   .copyWith(
                //                       fontWeight: centerInfoCtl.tabPosition == 1
                //                           ? FontWeight.w600
                //                           : FontWeight.w500)),
                //         ),
                //       ),
                //     )),
                //   ],
                // ),
                // Stack(
                //   children: [
                //     Container(
                //       width: width,
                //       height: 2,
                //       decoration: const BoxDecoration(color: Color(0xFFF2F2F2)),
                //     ),
                //     SizedBox(
                //       width: width,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           centerInfoCtl.tabPosition == 0
                //               ? Container(
                //                   width: width / 2,
                //                   height: 2,
                //                   color: const Color(0xff3E9CE2),
                //                 )
                //               : Container(),
                //           centerInfoCtl.tabPosition == 1
                //               ? Container(
                //                   width: width / 2,
                //                   height: 2,
                //                   color: const Color(0xff3E9CE2),
                //                 )
                //               : Container()
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: centerInfoCtl.tabPosition == 0
                      ? _map(centerInfoModel)
                      : _centerInfo(centerInfoModel),
                ),
              ]),
              centerInfoCtl.tabPosition == 0
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: _footerContents(centerInfoModel),
                    )
                  : Container()
            ],
          ),
        ));
  }

  bool _isMapReady = false;

  Widget _map(CenterInfoModel centerInfoModel) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 8,
            children: centerInfoModel.data.center_info!.center_category!
                .map((String name) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          border: Border.all(
                              width: 1, color: WDColors.searchBoarder),
                          color: WDColors.white),
                      child: Text(name,
                          style: AppTextStyles.body6(WDColors.neutral)),
                    ))
                .toList(),
          ),
          const SizedBox(
            height: 40,
          ),
          //ic_center_career.png
          //center_profile
          //
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (centerInfoModel.data.center_info != null &&
                  centerInfoModel.data.center_info?.center_profile != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset(
                                'assets/images/ic_center_career.png'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '상담 센터 약력',
                            style: Styler.style(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                          centerInfoModel
                              .data.center_info!.center_profile!.length, (idx) {
                        CenterProfile data = centerInfoModel
                            .data.center_info!.center_profile![idx];
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: idx ==
                                      centerInfoModel.data.center_info!
                                              .center_profile!.length -
                                          1
                                  ? 40
                                  : 13),
                          child: SizedBox(
                            width: width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.year.toString(),
                                  style: Styler.style(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                      color: WDColors.black2),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                    child: Text(
                                  data.content,
                                  style: Styler.style(
                                      color: WDColors.neutral,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5),
                                  maxLines: null,
                                ))
                              ],
                            ),
                          ),
                        );
                      }),
                    )
                  ],
                )
            ],
          ),

          Text('상담 센터 위치', style: AppTextStyles.body1(WDColors.black)),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: width,
            height: 205,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Stack(
                children: [
                  NaverMap(
                    options: NaverMapViewOptions(
                        indoorEnable: true, // 실내 맵 사용 가능 여부 설정
                        locationButtonEnable: false, // 위치 버튼 표시 여부 설정
                        consumeSymbolTapEvents: false, // 심볼 탭 이벤트 소비 여부 설정
                        initialCameraPosition: NCameraPosition(
                            target: NLatLng(
                                double.parse(
                                    centerInfoModel.data.center_info!.latitude),
                                double.parse(centerInfoModel
                                    .data.center_info!.longitude)),
                            zoom: 12)),
                    onMapReady: (controller) async {
                      // 지도 준비 완료 시 호출되는 콜백 함수
                      if (!centerInfoCtl.mapControllerCompleter.isCompleted) {
                        centerInfoCtl.mapControllerCompleter.complete(
                            controller); // Completer에 지도 컨트롤러 완료 신호 전송
                      }
                      centerInfoCtl.nController = controller;
                      centerInfoCtl
                          .requestCenterInfo(widget.center_id)
                          .then((value) async {
                        centerInfoCtl.nController.clearOverlays();
                        centerInfoCtl.addMarker(
                            context,
                            centerInfoCtl.nController,
                            double.parse(
                                centerInfoModel.data.center_info!.latitude),
                            double.parse(
                                centerInfoModel.data.center_info!.longitude));
                      });
                      Future.delayed(const Duration(milliseconds: 100))
                          .whenComplete(() {
                        setState(() {
                          _isMapReady = true;
                        });
                      });
                    },
                  ),
                  !_isMapReady
                      ? Container(
                          width: width,
                          height: 205,
                          color: Colors.white,
                          child: Center(
                            child: SizedBox(
                              height: 100,
                              child: Lottie.asset(
                                  'assets/json/loading_animation.json',
                                  fit: BoxFit.fitHeight,
                                  renderCache: RenderCache.raster),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(centerInfoModel.data.center_info!.center_addr,
              style: AppTextStyles.body4(WDColors.black2)
                  .copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _centerInfo(CenterInfoModel centerInfoModel) {
    return _counselorList(centerInfoModel);
  }

  //전화하기 -> 확인 으로 바뀌고 뒤로 가기
  Widget _footerContents(CenterInfoModel centerInfoModel) {
    return WDBtn(
        text: '확인',
        width: width,
        height: 52,
        function: () {
          Navigator.pop(context);
        });
  }

  // Widget _footerContents(CenterInfoModel centerInfoModel) {
  //   return WDBtn(
  //       text: '전화하기',
  //       width: width,
  //       height: 52,
  //       function: () {
  //         WDCommon().dialNumber(centerInfoModel.data.center_info!.center_tel);
  //       });
  // }

  Widget _counselorList(CenterInfoModel centerInfoModel) {
    //centerInfoModel
    //                                             .data
    //                                             .counselor_info![index]
    //                                             .counselor_position
    return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: centerInfoModel.data.counselor_info!.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CounselorInfoView(
                              center_id:
                                  centerInfoModel.data.center_info!.center_id,
                              counsler_id: centerInfoModel
                                  .data.counselor_info![index].counselor_id,
                            )));
              },
              child: Container(
                color: Colors.transparent,
                width: width,
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://weedool-web-back.s3.ap-northeast-2.amazonaws.com/${centerInfoModel.data.counselor_info![index].counselor_img}'),
                              fit: BoxFit.cover),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                                WDCommon().replaceStringLength(
                                    centerInfoModel.data.counselor_info![index]
                                        .counselor_name,
                                    20),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body1(WDColors.black)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                centerInfoModel.data.counselor_info![index]
                                        .counselor_edu_info!.isNotEmpty
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12),
                                        child: Text(
                                            WDCommon().replaceStringLength(
                                                centerInfoModel
                                                    .data
                                                    .counselor_info![index]
                                                    .counselor_edu_info![0]
                                                    .major,
                                                18),
                                            textAlign: TextAlign.left,
                                            style: AppTextStyles.body6(
                                                WDColors.alternative)),
                                      )
                                    : Container(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: const BoxDecoration(
                                      color: WDColors.black,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Center(
                                    child: Text(
                                        centerInfoModel
                                            .data
                                            .counselor_info![index]
                                            .counselor_position,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.detail2(
                                                WDColors.white)
                                            .copyWith(
                                                fontWeight: FontWeight.w500)),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    Image.asset('assets/images/ic_chart_arrow_right.png',
                        width: 7, height: 12, fit: BoxFit.contain),
                  ],
                ),
              ));
        });
  }
}
