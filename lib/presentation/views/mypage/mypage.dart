import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weedool/component/wd_toggle.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_text_style.dart';

import 'package:weedool/controllers/mypage/controller_mypage.dart';
import 'package:weedool/utils/device_info_util.dart';
import 'package:weedool/utils/package_util.dart';
import 'package:weedool/utils/permission_util.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/views/loading_page.dart';
import 'package:weedool/views/login/check_agency.dart';

class MypageView extends StatefulWidget {
  const MypageView({Key? key}) : super(key: key);

  @override
  State<MypageView> createState() => _MypageState();
}

class _MypageState extends State<MypageView> with WidgetsBindingObserver {
  double height = 0;
  double width = 0;

  MypageCtl mypageCtl = MypageCtl();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _permissionUtil.checkNotiPermission();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (permissionOn) {
          _permissionUtil.checkNotiPermission();
          // PermissionUtil().requestLocationPermission(
          //     isInit: true,
          //     successFunction: () async {
          //       tabHomeCtl.setLocation();
          //       // await Location().getLocation().then((value) {
          //       //   setState(() {
          //       //     WDCommon()
          //       //         .setSelectedPosition(value.latitude, value.longitude);
          //       //   });
          //       // });
          //     });
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
    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        if (!didPop) {
          didPop = true;
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      },
      child: _body(),
    );
  }

  Widget _body() {
    return Scaffold(
      backgroundColor: WDColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: Stack(children: [
            Container(
              width: width,
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerContents(),

                    Container(
                      width: width,
                      height: height - 100,
                      child: _bodyContents(),
                    )
                    // _footContents()
                  ]),
            ),
            LoadingPage(isLoading: mypageCtl.isLoading)
          ])),
    );
  }

  bool didPop = false;

  Widget _headerContents() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16),
      child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              if (!didPop) {
                didPop = true;
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              }
            },
            child: SizedBox(
                width: 24,
                height: 24,
                child: Image.asset('assets/images/ic_btn_back.png',
                    width: 24, height: 24, fit: BoxFit.contain)),
          )),
    );
  }

  final PermissionUtil _permissionUtil = PermissionUtil();

  Widget _bodyContents() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            width: 116,
            height: 116,
            child: Image.asset('assets/images/ic_mypage_emotion.png',
                width: 116, height: 116, fit: BoxFit.contain),
          ),
          const SizedBox(
            height: 16,
          ),
          Text('${WDCommon().nickName} 님',
              style: AppTextStyles.heading3(WDColors.black)
                  .copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 80),
          Container(
            decoration: const BoxDecoration(
                color: WDColors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    WDCommon()
                        .toast(context, '앱 버전은 ${PackageUtil().version}입니다');
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 56,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('앱 정보',
                            style: AppTextStyles.body4(WDColors.black2)),
                        const Spacer(),
                        Image.asset('assets/images/ic_mypage_arrow.png',
                            width: 24, height: 24, fit: BoxFit.none)
                      ],
                    ),
                  ),
                ),
                Container(
                  width: width,
                  height: 1,
                  decoration: const BoxDecoration(color: Color(0xFFE3E2E2)),
                ),
                GestureDetector(
                  onTap: () {
                    mypageCtl.showPopLogout(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 56,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('로그아웃',
                            style: AppTextStyles.body4(WDColors.black2)),
                        const Spacer(),
                        Image.asset('assets/images/ic_mypage_arrow.png',
                            width: 24, height: 24, fit: BoxFit.none)
                      ],
                    ),
                  ),
                ),
                Container(
                  width: width,
                  height: 1,
                  decoration: const BoxDecoration(color: Color(0xFFE3E2E2)),
                ),
                GestureDetector(
                  onTap: () {
                    mypageCtl.showPopResign(context, () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const CheckAgencyView()),
                          (route) => false);
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 56,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('회원 탈퇴',
                            style: AppTextStyles.body4(WDColors.black2)),
                        const Spacer(),
                        Image.asset('assets/images/ic_mypage_arrow.png',
                            width: 24, height: 24, fit: BoxFit.none)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 36),
            child: Container(
              width: width,
              height: 1,
              color: WDColors.tabActivityChartBack,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '알림 설정',
                      style: Styler.style(
                          height: 1.5,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      '필요한 정보들을 알림으로 알려줘요',
                      style: Styler.style(
                          color: WDColors.alternative,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          fontSize: 14),
                    )
                  ],
                ),
                ValueListenableBuilder(
                    valueListenable: _permissionUtil.notiPermission,
                    builder: (_, value, child) {
                      return WDToggle(
                          function: () async {
                            if (value) {
                              await openAppSettings().then((_) {
                                permissionOn = true;
                              });
                            } else {
                              if (Platform.isAndroid) {
                                if (_deviceInfoUtil.android!.version.sdkInt >=
                                    33) {
                                  _permissionUtil
                                      .requestNotiPermission(() async {
                                    await openAppSettings().then((_) {
                                      permissionOn = true;
                                    });
                                  });
                                } else {
                                  await openAppSettings().then((_) {
                                    permissionOn = true;
                                  });
                                }
                              } else {
                                _permissionUtil.requestNotiPermission(() async {
                                  await openAppSettings().then((_) {
                                    permissionOn = true;
                                  });
                                });
                              }
                            }
                          },
                          isSelected: value);
                    })
              ],
            ),
          )
          //WDToggle
        ],
      ),
    );
  }

  final DeviceInfoUtil _deviceInfoUtil = DeviceInfoUtil();
  bool permissionOn = false;
}
