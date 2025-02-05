import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_text_style.dart';

import 'dart:developer' as developer;

import 'package:weedool/models/model_base.dart';
import 'package:weedool/utils/preference_util.dart';
import 'package:weedool/views/loading_page.dart';

class MoodCheckView extends StatefulWidget {
  const MoodCheckView({Key? key}) : super(key: key);

  @override
  State<MoodCheckView> createState() => _MoodCheckState();
}

class _MoodCheckState extends State<MoodCheckView> {
  double height = 0;
  double width = 0;

  List<String> listImage = [
    'assets/images/ic_mood_motion1.png',
    'assets/images/ic_mood_motion2.png',
    'assets/images/ic_mood_motion3.png',
    'assets/images/ic_mood_motion4.png',
    'assets/images/ic_mood_motion5.png'
  ];
  List<String> listMoodStr = ['너무 나빠요', '나빠요', '그저 그래요', '좋아요', '너무 좋아요'];

  int _selectedIndex = 2;

  bool _isLoading = false;

  Future<BaseModel> _requestCheckupDailyMood() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }
    developer.log('aaa');
    Map<String, dynamic> body = {
      'uuid': WDCommon().uuid,
      'emotion': _selectedIndex + 1
    };
    developer.log('bbb');
    final response = await WDApis().requestCheckupDailyMood(body);

    developer.log('ccc');
    developer.log("response : $response");

    setState(() {
      _isLoading = false;
    });
    return response;
  }

  final PreferenceUtil _preferenceUtil = PreferenceUtil();

  @override
  void initState(){
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   _preferenceUtil.setCheckMood(true);
    // });
  }

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;
    return PopScope(
        canPop: false,
        child: Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.70),
        body: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 40),
                    // height: 500,
                    decoration: const BoxDecoration(
                        color: WDColors.white,
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '오늘 기분 어떠세요?',
                          style: AppTextStyles.heading2(WDColors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '현재 기분을 스크롤해서 표시해주세요.',
                          style: AppTextStyles.body2(const Color(0xFFA8A8A8)),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: const BoxDecoration(
                              color: Color(0xFFEDF3FA),
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                          child: Text(listMoodStr[_selectedIndex],
                              style: AppTextStyles.heading3(
                                  const Color(0xFF104E95))),
                        ),
                        const SizedBox(
                          height: 34,
                        ),
                        SizedBox(
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(listImage.length, (idx) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = idx;
                                  });
                                },
                                child: SizedBox(
                                  width: 58,
                                  height: 58,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.white,
                                    backgroundImage: AssetImage(_selectedIndex ==
                                        idx
                                        ? 'assets/images/back_mood_selected.png'
                                        : 'assets/images/back_mood_unselected.png'),
                                    child: Center(
                                      child: SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: Image.asset(listImage[idx]),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        // SizedBox(
                        //   width: width,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       SizedBox(
                        //         width: 58,
                        //         child: Center(
                        //           child: Text(
                        //             '나빠요',
                        //             style:
                        //             AppTextStyles.detail2(WDColors.black),
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         width: 58,
                        //         child: Center(
                        //           child: Text(
                        //             '좋아요',
                        //             style:
                        //             AppTextStyles.detail2(WDColors.black),
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                            onTap: () {
                              _requestCheckupDailyMood().then((value) {
                                if (value.message != 'ok') {
                                  WDCommon().toast(context, value.data!.result_msg ?? '', isError: true);
                                }
                                _preferenceUtil.setCheckMood(false);
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              height: 52,
                              margin:
                              const EdgeInsets.symmetric(horizontal: 17),
                              decoration: const BoxDecoration(
                                  color: Color(0xff3E9CE2),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                              child: Center(
                                child: Text(
                                  "확인",
                                  style: AppTextStyles.body1(WDColors.white),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                LoadingPage(isLoading: _isLoading)
              ],
            ))));
  }
}
