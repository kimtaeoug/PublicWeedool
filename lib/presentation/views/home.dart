import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_text_style.dart';
import 'package:weedool/component/dialog.dart';
import 'package:weedool/controllers/tab/controller_tab%20_home.dart';
import 'package:weedool/utils/network_observer_util.dart';
import 'package:weedool/views/no_network_page.dart';
import 'package:weedool/views/tabs/tab_activity2.dart';
import 'package:weedool/views/tabs/tab_chart.dart';
import 'package:weedool/views/tabs/tab_home.dart';
import 'package:weedool/views/tabs/tab_reserve.dart';

import 'package:weedool/views/tabs/tab_test.dart';
import 'package:weedool/views/test/dmsls_test_page.dart';

class HomeView extends StatefulWidget {
  final int selectedIndex;

  const HomeView({
    super.key,
    required this.selectedIndex,
  });

  @override
  State<HomeView> createState() => _HomeState();
}

class _HomeState extends State<HomeView> {
  double height = 0;
  double width = 0;
  int _selectedIndex = 2;

  final TabHomeCtl tabHomeCtl = TabHomeCtl();

  void _onItemTapped(int index) {
    setState(() {
      if (index == 4) {
        if (WDCommon().dmsls_flag) {
          _selectedIndex = index;
        } else {
          if (tabHomeCtl.checkUpModel.value != null) {
            if (tabHomeCtl.checkUpModel.value?.data.mcq_flag == true) {
              showPopTest();
            } else {
              WDCommon().toast(
                  context, '아직 문진을 진행할 시간이 아니에요. 4주가 지난 후에 진행하실 수 있습니다',
                  isError: true);
            }
          }
        }
      } else {
        _selectedIndex = index;
      }
    });
  }

  void showPopTest() async {
    WDDialog.twoBtnDialog(context, '앗! 아직 검사 전이시네요.', '안 할래요', '검사하기',
        (dialogContext) {
      if (Navigator.canPop(dialogContext)) {
        Navigator.pop(dialogContext);
      }
    }, (dialogContext) {
      if (Navigator.canPop(dialogContext)) {
        Navigator.pop(dialogContext);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const DmslsTestPage(category: 'DMSLS')),
      );
    }, subTitle: '검사를 완료하고 오시면 활동이 표시될거예요');
  }

  SharedPreferences? preferences;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        setState(() {
          _selectedIndex = widget.selectedIndex;
        });
      }
      preferences = await SharedPreferences.getInstance();

      //checkUpModel
    });
  }

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;

    List<Widget> screenList = <Widget>[
      const TabReserveView(),
      const TabTestView(),
      const TabHomeView(),
      const TabChartView(),
      const TabActivity2()
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        WDDialog.twoBtnDialog(context, '앱을 종료하시겠습니까?', '아니요', '네',
            (dialogContext) {
          Navigator.pop(dialogContext);
        }, (dialogContext) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else {
            exit(0);
          }
        });
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(),
        child: Scaffold(
          body: Stack(children: [
            Positioned(
                top: 0,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: screenList[_selectedIndex],
                )),
            Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 3)
                      ],
                      color: WDColors.white),
                  width: width,
                  height: 83,
                  child: MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: TextScaler.noScaling),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _onItemTapped(0);
                                  });
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    width: width,
                                    height: height,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                            _selectedIndex == 0
                                                ? 'assets/images/ic_tab1_on.png'
                                                : 'assets/images/ic_tab1_off.png',
                                            width: 24,
                                            height: 24,
                                            fit: BoxFit.contain),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text('센터',
                                            textAlign: TextAlign.left,
                                            style: AppTextStyles.detail2(
                                                    _selectedIndex == 0
                                                        ? const Color(
                                                            0xff3E9CE2)
                                                        : const Color(
                                                            0xff989BA2))
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500))
                                      ],
                                    )))),
                        Flexible(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _onItemTapped(1);
                                  });
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    width: width,
                                    height: height,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                            _selectedIndex == 1
                                                ? 'assets/images/ic_tab2_on.png'
                                                : 'assets/images/ic_tab2_off.png',
                                            width: 24,
                                            height: 24,
                                            fit: BoxFit.contain),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text('검사',
                                            textAlign: TextAlign.left,
                                            style: AppTextStyles.detail2(
                                                    _selectedIndex == 1
                                                        ? const Color(
                                                            0xff3E9CE2)
                                                        : const Color(
                                                            0xff989BA2))
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500))
                                      ],
                                    )))),
                        Flexible(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _onItemTapped(2);
                                  });
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    width: width,
                                    height: height,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                            _selectedIndex == 2
                                                ? 'assets/images/ic_tab3_on.png'
                                                : 'assets/images/ic_tab3_off.png',
                                            width: 24,
                                            height: 24,
                                            fit: BoxFit.contain),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text('홈',
                                            textAlign: TextAlign.left,
                                            style: AppTextStyles.detail2(
                                                    _selectedIndex == 2
                                                        ? const Color(
                                                            0xff3E9CE2)
                                                        : const Color(
                                                            0xff989BA2))
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500))
                                      ],
                                    )))),
                        Flexible(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _onItemTapped(3);
                                  });
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    width: width,
                                    height: height,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                            _selectedIndex == 3
                                                ? 'assets/images/ic_tab4_on.png'
                                                : 'assets/images/ic_tab4_off.png',
                                            width: 24,
                                            height: 24,
                                            fit: BoxFit.contain),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text('요약',
                                            textAlign: TextAlign.left,
                                            style: AppTextStyles.detail2(
                                                    _selectedIndex == 3
                                                        ? const Color(
                                                            0xff3E9CE2)
                                                        : const Color(
                                                            0xff989BA2))
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500))
                                      ],
                                    )))),
                        Flexible(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _onItemTapped(4);
                                  });
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    width: width,
                                    height: height,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                            _selectedIndex == 4
                                                ? 'assets/images/ic_tab5_on.png'
                                                : 'assets/images/ic_tab5_off.png',
                                            width: 24,
                                            height: 24,
                                            fit: BoxFit.contain),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text('활동',
                                            textAlign: TextAlign.left,
                                            style: AppTextStyles.detail2(
                                                    _selectedIndex == 4
                                                        ? const Color(
                                                            0xff3E9CE2)
                                                        : const Color(
                                                            0xff989BA2))
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500))
                                      ],
                                    )))),
                      ],
                    ),
                  ),
                )),
            ValueListenableBuilder(
                valueListenable: _networkObserverUtil.network,
                builder: (_, value, child) {
                  if (value) {
                    return Container();
                  } else {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: TextScaler.noScaling),
                      child: const NoNetworkPage(),
                    );
                  }
                }),
          ]),
        ),
      ),
    );
  }

  final NetworkObserverUtil _networkObserverUtil = NetworkObserverUtil();
}
