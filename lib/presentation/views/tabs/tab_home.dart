import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weedool/component/dialog.dart';
import 'package:weedool/component/wd_location_btn.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_constants.dart';
import 'package:weedool/components/wd_text_style.dart';
import 'package:weedool/controllers/tab/controller_tab%20_home.dart';
import 'package:weedool/controllers/test/test_controller.dart';
import 'package:weedool/models/model_checkup.dart' as cm;
import 'package:weedool/utils/ga_util.dart';
import 'package:weedool/utils/permission_util.dart';
import 'package:weedool/utils/preference_util.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/views/activity/activity_check_ba.dart';
import 'package:weedool/views/loading_page.dart';
import 'package:weedool/views/mypage/mypage.dart';
import 'package:weedool/models/tab/model_main.dart';
import 'package:weedool/views/popup/pop_mood_check.dart';
import 'package:weedool/views/reserve/center_info.dart';
import 'package:weedool/views/test/dmsls_test_page.dart';

class TabHomeView extends StatefulWidget {
  const TabHomeView({Key? key}) : super(key: key);

  @override
  State<TabHomeView> createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHomeView> with WidgetsBindingObserver {
  double height = 0;
  double width = 0;

  TabHomeCtl tabHomeCtl = TabHomeCtl();

  final ValueNotifier<MainModel?> _mainModel = ValueNotifier(null);

  bool _checkDialogOpen = false;

  final DateTime today = DateTime.now();

  @override
  void initState() {
    GaUtil().trackScreen('HomePage', input: {'uuid': WDCommon().uuid});
    PermissionUtil().requestLocationPermission(successFunction: () async {
      tabHomeCtl.setLocation();
      MainModel response = await tabHomeCtl.requestMain();
      setState(() {
        _mainModel.value = response;
        tabHomeCtl.loading.value = false;
      });
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // tabHomeCtl.setLocation();

    if (!tabHomeCtl.isLoading) {
      setState(() {
        tabHomeCtl.isLoading = true;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      MainModel response = await tabHomeCtl.requestMain();
      setState(() {
        WDCommon().nickName = response.data.nick_name;
        WDCommon().dmsls_flag = response.data.dmsls_flag;
        _mainModel.value = response;
        tabHomeCtl.isLoading = false;
        tabHomeCtl.loading.value = false;
        showCenterBox.value = true;
      });
      _intakeFunction(response.data);
      cm.CheckupModel check = await testController.requestCheckup('DMSLS');
      setState(() {
        tabHomeCtl.checkUpModel.value = check;
      });
    });
  }

  final Duration _delayDuration = Duration(milliseconds: 500);

  // final ValueNotifier<bool> showCharacter = ValueNotifier(false);
  //   final ValueNotifier<bool> showActivityBox = ValueNotifier(false);
  //   final ValueNotifier<bool> showCenterBox = ValueNotifier(false);

  final TestController testController = TestController();

  final PreferenceUtil _preferenceUtil = PreferenceUtil();

  void _moodFunction(Data data) {
    if (!data.mood_flag) {
      if (_checkDialogOpen == false) {
        if (!_preferenceUtil.sleep) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            tabHomeCtl.showPopDaily(context, function: () {
              _preferenceUtil.setCheckSleep(true);
              setState(() {
                _checkDialogOpen = true;
              });
            });
          });
        } else {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false, // set to false
              pageBuilder: (_, __, ___) => const MoodCheckView(),
            ),
          );
          // WDLog.e('mood : ${_preferenceUtil.mood}');
          // if (!_preferenceUtil.mood) {
          //   Navigator.of(context).push(
          //     PageRouteBuilder(
          //       opaque: false, // set to false
          //       pageBuilder: (_, __, ___) => const MoodCheckView(),
          //     ),
          //   );
          // } else {
          //   WDLog.e('hey3');
          // }
        }
      }
    }
  }

  void _intakeFunction(Data data) {
    if (!data.intake_flag) {
      if (!WDCommon().intake_flag) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          tabHomeCtl.showPopTest(context, () {
            _moodFunction(data);
          });
        });
      }
    } else {
      _moodFunction(data);
    }
  }

  bool hey = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (permissionOn) {
          PermissionUtil().requestLocationPermission(
              isInit: true,
              successFunction: () async {
                tabHomeCtl.setLocation();
                MainModel response = await tabHomeCtl.requestMain();
                setState(() {
                  _mainModel.value = response;
                  tabHomeCtl.loading.value = false;
                });
                // await Location().getLocation().then((value) {
                //   setState(() {
                //     WDCommon()
                //         .setSelectedPosition(value.latitude, value.longitude);
                //   });
                // });
              });
          permissionOn = false;
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/back_gradient.png'),
                      fit: BoxFit.cover),
                ),
                child: ValueListenableBuilder(
                    valueListenable: _mainModel,
                    builder: (_, value, child) {
                      return value != null
                          ? SizedBox(
                              height: height,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _headerContents(),
                                    _bodyContents(value)
                                  ],
                                ),
                              ),
                            )
                          : Container();
                    }),
              ),
              LoadingPage(isLoading: tabHomeCtl.isLoading)
            ])));
  }

  Widget _headerContents() {
    return SizedBox(
      height: heightHeader,
      width: width,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(
              right: 10, top: MediaQuery.of(context).padding.top),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false, // set to false
                    pageBuilder: (_, __, ___) => const MypageView(),
                  ),
                );
              },
              icon: Image.asset(
                'assets/images/ic_profile.png',
                width: 21,
                height: 21,
              )),
        ),
      ),
    );
  }

  final ValueNotifier<bool> showCharacter = ValueNotifier(false);
  final ValueNotifier<bool> showActivityBox = ValueNotifier(false);
  final ValueNotifier<bool> showCenterBox = ValueNotifier(false);

  Widget _bodyContents(MainModel mainModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: _characterBox(mainModel),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _baActivityBox(mainModel),
            _centerBox(mainModel),
            const SizedBox(
              height: 83,
            )
          ],
        )
      ],
    );
    // return SizedBox(
    //     height: height - heightHeader - heightBottomTab,
    //     child: SingleChildScrollView(
    //         physics: const ClampingScrollPhysics(),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisSize: MainAxisSize.max,
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           children: [
    //             _characterBox(mainModel),
    //             _baActivityBox(mainModel),
    //             // _reserveBox(),
    //             _centerBox(mainModel)
    //           ],
    //
    //           // children: [Container(), _reserveBox()],
    //         )));
  }

  void showPopTest() async {
    WDDialog.twoBtnDialog(context, '앗! 아직 검사 전이시네요.', '안 할래요', '검사하기',
        (dialogContext) {
      Navigator.pop(dialogContext);
    }, (dialogContext) {
      Navigator.pop(dialogContext);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DmslsTestPage(category: 'DMSLS')),
      );
    }, subTitle: '검사를 완료하고 오시면 활동이 표시될거예요');
  }

  Widget _baActivityBox(MainModel mainModel) {
    Color tagBackColor = const Color(0xFFF5EFFD);
    Color tagTxtColor = const Color(0xFF6C1CD3);

    if (mainModel.data.ba_today != null) {
      switch (mainModel.data.ba_today!.timetag[0]) {
        case '아침':
          tagBackColor = const Color(0xFFFFE68E);
          tagTxtColor = const Color(0xFFFF7E14);
          break;
        case '점심':
          tagBackColor = const Color(0xFFD7E9C7);
          tagTxtColor = const Color(0xFF599434);
          break;
        case '저녁':
          tagBackColor = const Color(0xFFD5E6F2);
          tagTxtColor = const Color(0xFF368ED5);
          break;
        case '무관':
          tagBackColor = const Color(0xFFF5EFFD);
          tagTxtColor = const Color(0xFF6C1CD3);
          break;
      }
    }

    return GestureDetector(
      onTap: () async {
        if (WDCommon().dmsls_flag) {
          if (mainModel.data.ba_today != null) {
            setState(() {
              tabHomeCtl.isLoading = true;
            });
            await tabHomeCtl.requestTodayActivity(mainModel).then((value) {
              setState(() {
                tabHomeCtl.isLoading = false;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BaCheckView(
                            activity: value,
                          )));
            });
          }
        } else {
          showPopTest();
        }
      },
      child: Container(
          width: width,
          margin: const EdgeInsets.only(left: 20, right: 20, top: 12),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 0.2)
              ]),
          child: !mainModel.data.dmsls_flag
              ? SizedBox(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('아직 활동이 없어요!',
                              textAlign: TextAlign.left,
                              style: AppTextStyles.heading3(WDColors.black)),
                          const SizedBox(
                            height: 8,
                          ),
                          Text('검사하시면 활동 추천이 떠요',
                              textAlign: TextAlign.left,
                              style:
                                  AppTextStyles.body6(const Color(0xFF858588))),
                        ],
                      ),
                      const Spacer(),
                      Image.asset('assets/images/ic_main_ba_complete.png',
                          width: 91, height: 91, fit: BoxFit.contain),
                    ],
                  ),
                )
              : (mainModel.data.ba_today == null
                  ? SizedBox(
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('오늘의 할 일 다했어요!',
                                  textAlign: TextAlign.left,
                                  style:
                                      AppTextStyles.heading3(WDColors.black)),
                              const SizedBox(
                                height: 8,
                              ),
                              Text('너무 축하해요!! 모두 끝냈어요!',
                                  textAlign: TextAlign.left,
                                  style: AppTextStyles.body6(
                                      const Color(0xFF858588))),
                            ],
                          ),
                          const Spacer(),
                          Image.asset('assets/images/ic_main_ba_complete.png',
                              width: 91, height: 91, fit: BoxFit.contain),
                        ],
                      ),
                    )
                  : SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                      color: tagBackColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4))),
                                  child: Text(
                                      mainModel.data.ba_today!.timetag[0],
                                      style:
                                          AppTextStyles.detail1(tagTxtColor))),
                              const SizedBox(
                                height: 13,
                              ),
                              SizedBox(
                                width: width - 180,
                                child: Text(
                                  WDCommon().replaceStringLength(
                                      mainModel.data.ba_today!.activity_name,
                                      17),
                                  style: AppTextStyles.heading3(WDColors.black),
                                  maxLines: null,
                                ),
                              ),

                              const SizedBox(
                                height: 6,
                              ),

                              // const Text("아침식사 30분 전 1잔",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.black54)),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                        'assets/images/ic_activity_ba_amount_gray.png',
                                        width: 16,
                                        height: 16,
                                        fit: BoxFit.contain),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(mainModel.data.ba_today!.activity_info,
                                        textAlign: TextAlign.left,
                                        style: AppTextStyles.body6(
                                            const Color(0xFF858588))),
                                  ])
                            ],
                          ),
                          const Spacer(),
                          CachedNetworkImage(
                            imageUrl:
                                "$serverImageUrl${mainModel.data.ba_today!.activity_id}.png",
                            height: 80,
                          )
                        ],
                      ),
                    ))),
    );
  }

  // Widget _reserveBox() {
  //   return Container(
  //       width: double.infinity,
  //       height: 174,
  //       margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 16),
  //       decoration: BoxDecoration(
  //           color: WDColors.white, borderRadius: BorderRadius.circular(20)),
  //       child: Column(children: [
  //         Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 25),
  //             child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(vertical: 10),
  //                     child: Container(
  //                         margin: const EdgeInsets.only(top: 10, bottom: 5),
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 10, vertical: 5),
  //                         decoration: BoxDecoration(
  //                             color: Colors.blue[100],
  //                             borderRadius:
  //                                 const BorderRadius.all(Radius.circular(20))),
  //                         child: const Text(
  //                           "예약완료",
  //                           style: TextStyle(
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w600,
  //                               fontFamily: pretendard),
  //                         )),
  //                   ),
  //                   const Text("충남힐링상담센터",
  //                       style: TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.w600,
  //                           color: Colors.black87,
  //                           fontFamily: pretendard)),
  //                   const Padding(
  //                       padding: EdgeInsets.symmetric(vertical: 10),
  //                       child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Row(children: [
  //                               Text("1.8 (월)",
  //                                   style: TextStyle(
  //                                       fontSize: 16,
  //                                       fontWeight: FontWeight.w600,
  //                                       color: Colors.black87,
  //                                       fontFamily: pretendard)),
  //                               VerticalDivider(),
  //                               Text("오전 11:00",
  //                                   style: TextStyle(
  //                                       fontSize: 16,
  //                                       fontWeight: FontWeight.w600,
  //                                       color: Colors.black87,
  //                                       fontFamily: pretendard)),
  //                             ]),
  //                             Text("김상인 상담사",
  //                                 style: TextStyle(
  //                                     fontSize: 16,
  //                                     fontWeight: FontWeight.w500,
  //                                     color: Colors.black87,
  //                                     fontFamily: pretendard)),
  //                           ])),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(vertical: 3.0),
  //                     child: SizedBox(
  //                       width: double.infinity,
  //                       child: SfLinearGauge(
  //                         onGenerateLabels: () {
  //                           return <LinearAxisLabel>[
  //                             const LinearAxisLabel(text: '에약요청', value: 0),
  //                             const LinearAxisLabel(text: '요청 확인중', value: 1),
  //                             const LinearAxisLabel(text: '예약완료', value: 2),
  //                           ];
  //                         },
  //                         maximum: 2,
  //                         interval: 1,
  //                         showTicks: false,
  //                         showLabels: true,
  //                         animateAxis: true,
  //                         axisTrackStyle: LinearAxisTrackStyle(
  //                           thickness: 5,
  //                           edgeStyle: LinearEdgeStyle.bothCurve,
  //                           borderWidth: 1,
  //                           borderColor: Colors.grey[330],
  //                           color: Colors.grey[330],
  //                         ),
  //                         barPointers: <LinearBarPointer>[
  //                           LinearBarPointer(
  //                               value: 2,
  //                               thickness: 3,
  //                               edgeStyle: LinearEdgeStyle.bothCurve,
  //                               shaderCallback: (Rect bounds) {
  //                                 return const LinearGradient(colors: <Color>[
  //                                   Color(0xFF55A9E6),
  //                                   Color(0xFFA6CB88)
  //                                 ], stops: <double>[
  //                                   0.1,
  //                                   0.9,
  //                                 ]).createShader(bounds);
  //                               }),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ])),
  //       ]));
  // }

  //tabHomeCtl.loading
  Widget _centerBox(MainModel mainModel) {
    return ValueListenableBuilder(
        valueListenable: PermissionUtil().locationPermission,
        builder: (_, value, child) {
          if (value) {
            return ValueListenableBuilder(
                valueListenable: tabHomeCtl.loading,
                builder: (_, value3, child) {
                  if (value3) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 16, bottom: 14, left: 20, right: 20),
                      child: Container(
                        width: width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 22),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8)
                            ]),
                        child: Center(
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Lottie.asset(
                                'assets/json/loading_animation.json',
                                width: 100,
                                height: 100,
                                renderCache: RenderCache.raster),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return ValueListenableBuilder(
                        valueListenable: WDCommon().latLng,
                        builder: (_, value2, child) {
                          var distance = WDCommon().calculateDistance(
                              value2.latitude,
                              value2.longitude,
                              double.parse(mainModel.data.centerInfo!.latitude),
                              double.parse(
                                  mainModel.data.centerInfo!.longitude));
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CenterInfoView(
                                            center_id: mainModel
                                                .data.centerInfo!.center_id,
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: WDColors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8)
                                  ]),
                              width: width,
                              margin: const EdgeInsets.only(
                                  bottom: 14, left: 20, right: 20, top: 16),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      '내 기준 가장 가까운 센터',
                                      style: Styler.style(
                                          color: WDColors.alternative,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.32,
                                          height: 1.5),
                                    ),
                                  ),
                                  // Container(
                                  //   decoration: const BoxDecoration(
                                  //       color: WDColors.grayBack,
                                  //       borderRadius: BorderRadius.all(Radius.circular(4))),
                                  //   padding: const EdgeInsets.symmetric(horizontal: 6),
                                  //   child: Text(
                                  //     '내 기준 가장 가까운 센터',
                                  //     style: Styler.style(
                                  //         color: WDColors.alternative,
                                  //         fontSize: 13,
                                  //         fontWeight: FontWeight.w600,
                                  //         letterSpacing: -0.32,
                                  //         height: 1.5),
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    height: 11,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'https://weedool-web-back.s3.ap-northeast-2.amazonaws.com/${mainModel.data.centerInfo!.center_image.main_image_path}'),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                          child: SizedBox(
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 7.5),
                                              child: Text(
                                                WDCommon().replaceStringLength(
                                                    mainModel.data.centerInfo!
                                                        .center_name,
                                                    15),
                                                textAlign: TextAlign.left,
                                                style: AppTextStyles.heading3(
                                                    WDColors.black),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (mainModel.data.centerInfo!
                                                      .speciality.isNotEmpty)
                                                    Text(
                                                      WDCommon()
                                                          .replaceStringLength(
                                                              mainModel
                                                                  .data
                                                                  .centerInfo!
                                                                  .speciality[0],
                                                              15),
                                                      textAlign: TextAlign.left,
                                                      style:
                                                          AppTextStyles.body6(
                                                              WDColors
                                                                  .alternative),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                          'assets/images/ic_center_distance.png',
                                                          width: 8,
                                                          height: 11,
                                                          fit: BoxFit.contain),
                                                      const SizedBox(
                                                        width: 6,
                                                      ),
                                                      Text(
                                                          "${distance < 1 ? 1 : distance > 1000 ? 1000 : distance.toInt()}km",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: AppTextStyles
                                                              .body6(WDColors
                                                                  .alternative)),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 6),
                                                        width: 1,
                                                        height: 12,
                                                        color: WDColors.gray300,
                                                      ),
                                                      Text(
                                                        WDCommon().replaceStringLength(
                                                            WDCommon().addrReplace(
                                                                mainModel
                                                                    .data
                                                                    .centerInfo!
                                                                    .location),
                                                            15),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: AppTextStyles
                                                            .body6(WDColors
                                                                .alternative),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                });
          } else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14, top: 16),
              child: WDLocationBtn(function: () async {
                PermissionUtil().requestLocationPermission(
                    isInit: false,
                    function: () async {
                      await openAppSettings().then((_) {
                        permissionOn = true;
                      });
                    },
                    successFunction: () async {
                      tabHomeCtl.setLocation();
                      // await Location().getLocation().then((value) {
                      //   setState(() {
                      //     WDCommon().setSelectedPosition(
                      //         value.latitude, value.longitude);
                      //   });
                      // });
                    });
              }),
            );
          }
        });
  }

  bool permissionOn = false;

  Widget _characterBox(MainModel mainModel) {
    return SizedBox(
      width: width,
      height: 300,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                  height: 231,
                  width: 231,
                  child: Opacity(
                    opacity: 1,
                    child: Image.asset('assets/images/ic_home_img.png'),
                  ))),
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                // height: 160,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${mainModel.data.nick_name} 님,",
                          style: AppTextStyles.heading2(WDColors.white)),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(mainModel.data.quotes,
                          style: AppTextStyles.body1(WDColors.white))
                    ]),
              )),
        ],
      ),
    );
  }
}
