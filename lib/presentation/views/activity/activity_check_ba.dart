import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weedool/component/wd_time_chip.dart';
import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_constants.dart';
import 'package:weedool/components/wd_text_style.dart';
import 'package:weedool/models/activity/model_calendar_daily.dart';

import 'package:weedool/models/activity/model_check_ba.dart';
import 'package:weedool/utils/ga_util.dart';
import 'package:weedool/utils/logger.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/utils/ui_util.dart';
import 'package:weedool/views/home.dart';
import 'package:weedool/views/loading_page.dart';
import 'package:weedool/views/popup/pop_ba_check_result.dart';

class BaCheckView extends StatefulWidget {
  final Activity activity;

  const BaCheckView({Key? key, required this.activity}) : super(key: key);

  @override
  State createState() => _BaCheckState();
}

class _BaCheckState extends State<BaCheckView> {
  int _pageIndex = 0;

  int _beforeImageIndex = 0;

  int _afterImageIndex = 0;

  String _checkStartTime = '';
  String _checkEndTime = '';

  double height = 0;
  double width = 0;
  String beforeTitleText = "행동하시기 전,\n지금 감정이 어떠세요?";
  String beforeSubTitleText = "지금 그대로 솔직하게 선택해주실수록 좋아요.";

  String afterTitleText = "행동하신 후,\n지금 감정이 어떠세요?";
  String afterSubTitleText = "지금 그대로 솔직하게 선택해주실수록 좋아요.";

  List<String> listMoodStr = ['너무 나빠요', '나빠요', '그저 그래요', '좋아요', '너무 좋아요'];
  List<String> listMoodImage = [
    'assets/images/ic_mood_motion1.png',
    'assets/images/ic_mood_motion2.png',
    'assets/images/ic_mood_motion3.png',
    'assets/images/ic_mood_motion4.png',
    'assets/images/ic_mood_motion5.png'
  ];
  List<String> listMainImage = [
    'assets/images/ic_main_motion1.png',
    'assets/images/ic_main_motion2.png',
    'assets/images/ic_main_motion3.png',
    'assets/images/ic_main_motion4.png',
    'assets/images/ic_main_motion5.png'
  ];
  List<bool> listStarCheck = [false, false, false, false, false];

  bool _isLoading = false;

  // character_emotion_1.png
  // character_head_emotion_1.png

  double _beekHeight = 0;
  double _edbkHeight = 0;
  double _aevkHeight = 0;
  double _chipHeight = 0;
  double _titleHeight = 0;

  final TextStyle _chipStyle = Styler.style(
    fontWeight: FontWeight.w600,
    fontSize: 13,
  );

  @override
  void initState() {
    GaUtil().trackScreen('ActivityCheckPage',
        input: {'uuid': WDCommon().uuid, 'activity': widget.activity.toJson()});
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double beekHeight = UiUtil.widgetSize(_BEEK)?.height ?? 0;
      double edbkHeight = UiUtil.widgetSize(_EDBK)?.height ?? 0;
      double aevkHeight = UiUtil.widgetSize(_AEVK)?.height ?? 0;
      double titleHeight = UiUtil.textSize('목시A롤', _titleStyle).height;
      double chipHeight = UiUtil.textSize("목시A롤", _chipStyle).height;
      setState(() {
        _beekHeight = beekHeight;
        _edbkHeight = edbkHeight;
        _aevkHeight = aevkHeight;
        _titleHeight = titleHeight;
        _chipHeight = chipHeight + 2;
      });
    });
  }

  Future<BaCheckModel> _requestCheckActivityBa() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }
    Map<String, dynamic> body = {
      'uuid': WDCommon().uuid,
      'activity_id': widget.activity.activity_id,
      'start_time': _checkStartTime,
      'end_time': _checkEndTime,
      'achievement': listStarCheck
              .map((e) => e == true ? 1 : 0)
              .reduce((value, element) => value + element) *
          20,
      'emotion': {
        'before': _beforeImageIndex + 1,
        'after': _afterImageIndex + 1
      },
      'check': true
    };

    final response = await WDApis().requestCheckActivityBa(body);

    setState(() {
      _isLoading = false;
    });
    return response;
  }

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;

    return PopScope(
        onPopInvoked: (_) {
          _backFunction();
          // if (_pageIndex == 0) {
          //   Navigator.pop(context);
          // } else {
          //   setState(() {
          //     _pageIndex--;
          //   });
          // }
        },
        canPop: false,
        child: _body());
  }

  Widget _body() {
    final MediaQueryData data = MediaQuery.of(context);
    return Scaffold(
        body: MediaQuery(
            data: data.copyWith(
                textScaler:
                    data.textScaleFactor > 1 ? null : TextScaler.noScaling),
            child: Stack(
              children: [
                Column(
                  children: [
                    _headerContents(),
                    SizedBox(
                        width: width,
                        height:
                            height - (MediaQuery.of(context).padding.top + 40),
                        child: _bodyContents())
                  ],
                ),
                LoadingPage(isLoading: _isLoading)
              ],
            )));
  }

  ValueNotifier<bool> invokePop = ValueNotifier(false);

  void _backFunction() {
    if (_pageIndex == 0) {
      if (!invokePop.value) {
        invokePop.value = true;
        Navigator.pop(context);
      }
    } else {
      setState(() {
        _pageIndex--;
      });
    }
  }

  Widget _bodyContents() {
    switch (_pageIndex) {
      case 0:
        return _beforeEmotionView();
      case 1:
        return _emotionDescView();
      case 2:
        return _afterEmotionView();
      case 3:
        return _checkRatingView();
      default:
        return Container();
    }
  }

  Widget _headerContents() {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16, left: 18),
      width: width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            _backFunction();
          },
          child: SizedBox(
            width: 24,
            height: 24,
            child: Image.asset('assets/images/ic_btn_back.png'),
          ),
        ),
      ),
    );
  }

  //before Emotion Expanded key
  final GlobalKey _BEEK = GlobalKey();

  Widget _beforeEmotionView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 36, left: 33, right: 33),
                  child: Text(beforeTitleText,
                      textAlign: TextAlign.left,
                      style: AppTextStyles.heading1(WDColors.black)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 44),
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        listMainImage[_beforeImageIndex]),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                  color: WDColors.primaryColor.withOpacity(0.2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Text(listMoodStr[_beforeImageIndex],
                                  style: AppTextStyles.heading3(
                                      const Color(0xff104E95))),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 40, left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _addBeforeMoodItem(0),
                          _addBeforeMoodItem(1),
                          _addBeforeMoodItem(2),
                          _addBeforeMoodItem(3),
                          _addBeforeMoodItem(4),
                        ],
                      ),
                    ),
                  ],
                ),
                // Container(
                //   margin: const EdgeInsets.only(top: 8, left: 30, right: 30),
                //   width: width,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       SizedBox(
                //         width: 54,
                //         child: Center(
                //           child: Text('나빠요',
                //               style: AppTextStyles.body2(WDColors.gray)),
                //         ),
                //       ),
                //       SizedBox(
                //         width: 54,
                //         child: Center(
                //           child: Text('좋아요',
                //               style: AppTextStyles.body2(WDColors.gray)),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    key: _BEEK,
                    child: Container(
                      width: width,
                      color: Colors.transparent,
                    )),
                if (_beekHeight < 40)
                  SizedBox(
                    height: 40 - _beekHeight,
                  ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_pageIndex < 4) {
                          _pageIndex++;
                          _checkStartTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(DateTime.now());
                        }
                      });
                    },
                    child: Container(
                      width: width,
                      height: 52,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Color(0xFF41A7D7)),
                      child: Center(
                        child: Text('맞아요',
                            style: AppTextStyles.heading3(WDColors.white)),
                      ),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }

  //emotion desc view key
  final GlobalKey _EDBK = GlobalKey();

  Widget _emotionDescTimeChipList(
    List tagBackColorArr,
    List tagTxtColorArr,
  ) {
    return Padding(
      padding: EdgeInsets.only(
          left: 12, top: 3 * MediaQuery.of(context).textScaleFactor),
      child: Wrap(
        children: [
          WdTimeChip(
              text: widget.activity.time_tag[0],
              color: tagBackColorArr[0],
              textColor: tagTxtColorArr[0]),
          widget.activity.time_tag.length == 2
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: WdTimeChip(
                      text: widget.activity.time_tag[1],
                      color: tagBackColorArr[1],
                      textColor: tagTxtColorArr[1]),
                )
              : Container(),
          widget.activity.time_tag.length == 3
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: WdTimeChip(
                      text: widget.activity.time_tag[2],
                      color: tagBackColorArr[2],
                      textColor: tagTxtColorArr[2]),
                )
              : Container(),
        ],
      ),
    );
  }

  final TextStyle _titleStyle =
      AppTextStyles.heading2(WDColors.black).copyWith(height: 1.3);

  Widget _emotionTile(List tagBackColorArr, List tagTxtColorArr) {
    String title = widget.activity.activity * 2;
    List<Widget> txtList = List.generate(title.length + 3, (idx) {
      if (idx == title.length + 2) {
        if (widget.activity.time_tag.length == 3) {
          return Padding(
            padding: EdgeInsets.only(
                left: 8, top: 3 * MediaQuery.of(context).textScaleFactor),
            child: WdTimeChip(
                text: widget.activity.time_tag[2],
                color: tagBackColorArr[2],
                textColor: tagTxtColorArr[2]),
          );
        } else {
          return Container();
        }
      } else if (idx == title.length + 1) {
        if (widget.activity.time_tag.length == 2) {
          return Padding(
            padding: EdgeInsets.only(
                left: 8, top: 3 * MediaQuery.of(context).textScaleFactor),
            child: WdTimeChip(
                text: widget.activity.time_tag[1],
                color: tagBackColorArr[1],
                textColor: tagTxtColorArr[1]),
          );
        } else {
          return Container();
        }
      } else if (idx == title.length) {
        return Padding(
          padding: EdgeInsets.only(
              left: 12, top: 3 * MediaQuery.of(context).textScaleFactor),
          child: WdTimeChip(
              text: widget.activity.time_tag[0],
              color: tagBackColorArr[0],
              textColor: tagTxtColorArr[0]),
        );
      } else {
        return Text(
          title[idx],
          style: _titleStyle,
        );
      }
      if (idx == title.length) {
        return _emotionDescTimeChipList(
          tagBackColorArr,
          tagTxtColorArr,
        );
      } else {
        return Text(
          title[idx],
          style: _titleStyle,
        );
      }
    });
    return Wrap(
      children: txtList,
    );
  }

  Widget _emotionDescView() {
    List tagBackColorArr = [];
    List tagTxtColorArr = [];

    for (int i = 0; i < widget.activity.time_tag.length; i++) {
      Color tagBackColor = const Color(0xFFF5EFFD);
      Color tagTxtColor = const Color(0xFF6C1CD3);
      switch (widget.activity.time_tag[i]) {
        case '아침':
          tagBackColor = WDColors.mint;
          tagTxtColor = WDColors.mint;
          break;
        case '점심':
          tagBackColor = WDColors.secondary800;
          tagTxtColor = WDColors.secondary800;
          break;
        case '저녁':
          tagBackColor = WDColors.primary600;
          tagTxtColor = WDColors.primary600;
          break;
        case '무관':
          tagBackColor = WDColors.accentPurple;
          tagTxtColor = WDColors.accentPurple;
          break;
      }
      tagBackColorArr.add(tagBackColor);
      tagTxtColorArr.add(tagTxtColor);
    }

    return SizedBox(
      width: width,
      height: height - 100,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 40, left: 33, right: 33),
                      alignment: Alignment.topLeft,
                      child: _emotionTile(tagBackColorArr, tagTxtColorArr),
                      // child: Wrap(children: [
                      //   Text(widget.activity.activity,
                      //       textAlign: TextAlign.left,
                      //       style: AppTextStyles.heading2(WDColors.black)
                      //           .copyWith(height: 1.3)),
                      //   _emotionDescTimeChipList(
                      //       tagBackColorArr, tagTxtColorArr)
                      // ])
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 12, left: 33, right: 33),
                      alignment: Alignment.topLeft,
                      child: Text(widget.activity.description,
                          textAlign: TextAlign.left,
                          style: AppTextStyles.body4(WDColors.alternative)
                              .copyWith(fontWeight: FontWeight.w600)),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 12, left: 33),
                        alignment: Alignment.topLeft,
                        child: Row(children: [
                          Image.asset('assets/images/ic_activity_ba_amount.png',
                              width: 16, height: 16, fit: BoxFit.contain),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(widget.activity.amount_description,
                              textAlign: TextAlign.left,
                              style: AppTextStyles.body1(WDColors.black)),
                        ])),
                    Container(
                      margin: EdgeInsets.only(
                          top: widget.activity.activity_class == 'Weekly'
                              ? 50
                              : 72),
                      width: 243,
                      height: 243,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/back_activity_ba_check.png'),
                            fit: BoxFit.fill),
                      ),
                      child: Center(
                          child: SizedBox(
                              width: 175,
                              height: 175,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "$serverImageUrl${widget.activity.activity_id}.png",
                              ))),
                    ),
                    if (widget.activity.activity_class == 'Weekly')
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                widget.activity.act_done_days.length.toString(),
                                style: Styler.style(
                                    color: WDColors.strongBlue,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30,
                                    height: 1.5)),
                            Text(' /${widget.activity.count}',
                                style: Styler.style(
                                    color: WDColors.assitive,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5))
                          ],
                        ),
                      ),
                  ],
                ),
                Expanded(
                    key: _EDBK,
                    child: Container(
                      width: width,
                      color: Colors.transparent,
                    )),
                if (_edbkHeight < 40)
                  SizedBox(
                    height: 40 - _edbkHeight,
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_pageIndex < 4) {
                              _pageIndex++;
                            }
                          });
                        },
                        child: Container(
                          width: width,
                          height: 52,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              color: Color(0xff3E9CE2)),
                          child: const Center(
                            child: Text(
                              '다 했어요',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                  letterSpacing: -0.32,
                                  color: Colors.white,
                                  fontFamily: 'pretendard'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: width,
                          height: 52,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xff3E9CE2)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              color: Colors.white),
                          child: const Center(
                            child: Text(
                              '나중에 할래요',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                  letterSpacing: -0.32,
                                  color: Color(0xff3E9CE2),
                                  fontFamily: 'pretendard'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //AfterEmotionViewKey
  final GlobalKey _AEVK = GlobalKey();

  Widget _afterEmotionView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 36, left: 33, right: 33),
                    alignment: Alignment.topLeft,
                    child: Text(afterTitleText,
                        textAlign: TextAlign.left,
                        style: AppTextStyles.heading1(WDColors.black)),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 67,
                      ),
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage(listMainImage[_afterImageIndex]),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                            color: WDColors.primaryColor.withOpacity(0.2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Text(listMoodStr[_afterImageIndex],
                            style: AppTextStyles.heading3(
                                const Color(0xff104E95))),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _addAfterMoodItem(0),
                        _addAfterMoodItem(1),
                        _addAfterMoodItem(2),
                        _addAfterMoodItem(3),
                        _addAfterMoodItem(4),
                      ],
                    ),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.only(top: 8, left: 30, right: 30),
                  //   width: width,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       SizedBox(
                  //         width: 54,
                  //         child: Center(
                  //           child: Text('나빠요',
                  //               style: AppTextStyles.body2(
                  //                   const Color(0xff47484C))),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: 54,
                  //         child: Center(
                  //           child: Text('좋아요',
                  //               style: AppTextStyles.body2(
                  //                   const Color(0xff47484C))),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 46,
                  // ),
                ],
              )),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    key: _AEVK,
                    child: Container(
                      width: width,
                      color: Colors.transparent,
                    )),
                if (_aevkHeight < 40)
                  SizedBox(
                    height: 40 - _aevkHeight,
                  ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_pageIndex < 4) {
                          _pageIndex++;
                          _checkEndTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(DateTime.now());
                        }
                      });
                    },
                    child: Container(
                      width: width,
                      height: 52,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Color(0xFF41A7D7)),
                      child: Center(
                        child: Text('맞아요',
                            style: AppTextStyles.heading3(WDColors.white)),
                      ),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _checkRatingView() {
    final double starSize = (width - 120) / 5;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 126, left: 33),
                alignment: Alignment.topLeft,
                child: Text('스스로 얼마나\n활동을 열심히 하셨나요?',
                    textAlign: TextAlign.left,
                    style: AppTextStyles.heading2(WDColors.black)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40, left: 33, right: 33),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          listStarCheck[0] = true;
                          listStarCheck[1] = false;
                          listStarCheck[2] = false;
                          listStarCheck[3] = false;
                          listStarCheck[4] = false;
                        });
                      },
                      child: SizedBox(
                        width: starSize,
                        child: Image.asset(
                          listStarCheck[0]
                              ? 'assets/images/ic_star_on.png'
                              : 'assets/images/ic_star_off.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          listStarCheck[0] = true;
                          listStarCheck[1] = true;
                          listStarCheck[2] = false;
                          listStarCheck[3] = false;
                          listStarCheck[4] = false;
                        });
                      },
                      child: SizedBox(
                        width: starSize,
                        child: Image.asset(
                          listStarCheck[1]
                              ? 'assets/images/ic_star_on.png'
                              : 'assets/images/ic_star_off.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      // child: Container(
                      //   // margin: const EdgeInsets.only(right: 7.46),
                      //   width: 55,
                      //   height: 55,
                      //   decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //           image: AssetImage(listStarCheck[1]
                      //               ? 'assets/images/ic_star_on.png'
                      //               : 'assets/images/ic_star_off.png'),
                      //           fit: BoxFit.fill)),
                      // )
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          listStarCheck[0] = true;
                          listStarCheck[1] = true;
                          listStarCheck[2] = true;
                          listStarCheck[3] = false;
                          listStarCheck[4] = false;
                        });
                      },
                      child: SizedBox(
                        width: starSize,
                        child: Image.asset(
                          listStarCheck[2]
                              ? 'assets/images/ic_star_on.png'
                              : 'assets/images/ic_star_off.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      // child: Container(
                      //   // margin: const EdgeInsets.only(right: 7.46),
                      //   width: 55,
                      //   height: 55,
                      //   decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //           image: AssetImage(listStarCheck[2]
                      //               ? 'assets/images/ic_star_on.png'
                      //               : 'assets/images/ic_star_off.png'),
                      //           fit: BoxFit.fill)),
                      // )
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          listStarCheck[0] = true;
                          listStarCheck[1] = true;
                          listStarCheck[2] = true;
                          listStarCheck[3] = true;
                          listStarCheck[4] = false;
                        });
                      },
                      child: SizedBox(
                        width: starSize,
                        child: Image.asset(
                          listStarCheck[3]
                              ? 'assets/images/ic_star_on.png'
                              : 'assets/images/ic_star_off.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      // child: Container(
                      //   // margin: const EdgeInsets.only(right: 7.46),
                      //   width: 55,
                      //   height: 55,
                      //   decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //           image: AssetImage(listStarCheck[3]
                      //               ? 'assets/images/ic_star_on.png'
                      //               : 'assets/images/ic_star_off.png'),
                      //           fit: BoxFit.fill)),
                      // )
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          listStarCheck[0] = true;
                          listStarCheck[1] = true;
                          listStarCheck[2] = true;
                          listStarCheck[3] = true;
                          listStarCheck[4] = true;
                        });
                      },
                      child: SizedBox(
                        width: starSize,
                        child: Image.asset(
                          listStarCheck[4]
                              ? 'assets/images/ic_star_on.png'
                              : 'assets/images/ic_star_off.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      // child: Container(
                      //   width: 55,
                      //   height: 55,
                      //   decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //           image: AssetImage(listStarCheck[4]
                      //               ? 'assets/images/ic_star_on.png'
                      //               : 'assets/images/ic_star_off.png'),
                      //           fit: BoxFit.fill)),
                      // )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Container(
                width: width,
                color: Colors.transparent,
              )),
              Padding(
                padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
                child: GestureDetector(
                    onTap: () {
                      if (listStarCheck.first != false) {
                        setState(() {
                          _requestCheckActivityBa().then((value) {
                            {
                              if (value.message == 'ok') {
                                if (value.data!.error_code == 0) {
                                  _showDialog(value);
                                } else {
                                  WDCommon().toast(
                                      context, value.data!.result_msg,
                                      isError: true);
                                }
                              } else {
                                {
                                  WDCommon().toast(context, value.message,
                                      isError: true);
                                }
                              }
                            }
                          });
                        });
                      } else {
                        WDCommon().toast(context, '별점을 매겨주세요', isError: true);
                      }
                    },
                    child: Container(
                        width: width,
                        height: 52,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Color(0xFF41A7D7)),
                        child: Center(
                          child: Text(
                            '확인',
                            style: AppTextStyles.heading3(WDColors.white),
                          ),
                        ))),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _addBeforeMoodItem(int index) {
    return Padding(
      padding: EdgeInsets.zero,
      // padding: EdgeInsets.only(right: index == 4 ? 0 : 12.41),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _beforeImageIndex = index;
          });
        },
        child: SizedBox(
          width: 62,
          height: 62,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            backgroundImage: AssetImage(_beforeImageIndex == index
                ? 'assets/images/back_mood_selected.png'
                : 'assets/images/back_mood_unselected.png'),
            child: SizedBox(
              width: 54,
              height: 54,
              child: Image.asset(
                listMoodImage[index],
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //54, 46
  Widget _addAfterMoodItem(int index) {
    return Padding(
      padding: EdgeInsets.zero,
      // padding: EdgeInsets.only(right: index == 4 ? 0 : 12.41),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _afterImageIndex = index;
          });
        },
        child: SizedBox(
          width: 62,
          height: 62,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            backgroundImage: AssetImage(_afterImageIndex == index
                ? 'assets/images/back_mood_selected.png'
                : 'assets/images/back_mood_unselected.png'),
            child: SizedBox(
              width: 54,
              height: 54,
              child: Image.asset(
                listMoodImage[index],
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _addDoneDayItem() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: widget.activity.act_done_days.length,
        itemBuilder: (BuildContext ctx, int idx) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 65,
            height: 94,
            child: Column(
              children: [
                SizedBox(
                  width: 65,
                  height: 67,
                  child: Stack(
                    children: [
                      Positioned(
                          right: 2,
                          bottom: 0,
                          child: Image.asset(
                              'assets/images/ic_ba_motion_back.png',
                              width: 53,
                              height: 53,
                              fit: BoxFit.fill)),
                      Positioned(
                          right: 0,
                          bottom: 6,
                          child: Image.asset(
                              'assets/images/ic_ba_check_done.png',
                              width: 17,
                              height: 17,
                              fit: BoxFit.fill)),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: Image.asset(
                              'assets/images/ic_ba_motion_done.png',
                              width: 63,
                              height: 63,
                              fit: BoxFit.fill))
                    ],
                  ),
                ),
                SizedBox(
                    width: 65,
                    height: 27,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(widget.activity.act_done_days[idx],
                          textAlign: TextAlign.left,
                          style: AppTextStyles.body1(const Color(0xFF4A4A4A))),
                    ))
              ],
            ),
          );
        });
  }

  bool _checkDayWeekEnd(bool isWeek, bool dailyEnd, bool weeklyEnd) {
    if (isWeek) {
      return weeklyEnd;
    } else {
      return dailyEnd;
    }
  }

  void _showDialog(BaCheckModel value) {
    WDLog.e('value : ${value.data?.toJson()}');
    bool isWeek = widget.activity.activity_class == 'Weekly';
    bool dailyEnd = value.data!.daily_end;
    bool weeklyEnd = value.data!.weekly_end;
    WDLog.e('isWeek : $isWeek, dailyEnd : $dailyEnd, weeklyEnd : $weeklyEnd');
    bool isEnd = _checkDayWeekEnd(isWeek, dailyEnd, weeklyEnd);
    showDialog(
        context: context,
        builder: (context) {
          return BaCheckResultPop(
              isWeek ? value.data!.weekly_progress : [],
              isEnd ? '할 일 모두 완료' : '또 하나 완료했어요!',
              isEnd
                  ? '너무 축하해요!! 모두 끝났어요!\n요약보러 가실래요?'
                  : '너무 잘하고 있어요. 나머지도 다 끝내버릴까요?',
              '아니요',
              '네', (str) {
            Navigator.pop(context);

            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false, // set to false
                pageBuilder: (_, __, ___) => HomeView(selectedIndex: 2),
              ),
            );
          }, (str) {
            Navigator.pop(context);
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false, // set to false
                pageBuilder: (_, __, ___) =>
                    HomeView(selectedIndex: isEnd ? 3 : 4),
              ),
            );
          });
        });
  }
}
