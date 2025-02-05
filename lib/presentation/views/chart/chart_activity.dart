import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/component/achieve_rate_satis.dart';
import 'package:weedool/component/wb_activity_chart.dart';
import 'package:weedool/component/wd_achievement_log_chart.dart';
import 'package:weedool/component/wd_emotion_legend.dart';
import 'package:weedool/component/wd_mood_chart.dart';
import 'package:weedool/component/wd_no_data_guide.dart';
import 'package:weedool/component/wd_pie_chart.dart';
import 'package:weedool/component/wd_tab_bar.dart';
import 'package:weedool/components/wd_apis.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_text_style.dart';
import 'package:weedool/components/widgets/categorical_radar_chart.dart';
import 'package:weedool/models/chart/model_chart_daily.dart';
import 'package:weedool/models/chart/model_chart_monthly.dart';

import 'package:weedool/models/chart/model_chart_weekly.dart';
import 'package:weedool/utils/ga_util.dart';
import 'package:weedool/utils/logger.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/views/loading_page.dart';

class ChartActivityView extends StatefulWidget {
  const ChartActivityView({Key? key}) : super(key: key);

  @override
  State<ChartActivityView> createState() => _ChartActivityState();
}

class _ChartActivityState extends State<ChartActivityView> {
  double height = 0;
  double width = 0;

  bool _isLoading = false;

  int _tabIndex = 0;

  bool isLoaded = false;
  bool monthAchievement = false;
  bool weekAchievement = false;
  bool monthRadar = false;
  List<List?> todayData = [];
  List<String> doughnutLegends = ["긍정적 변화", "부정적 변화", "유지"];
  List<Color> doughnutLegendsColor = [
    WDColors.primaryColor,
    WDColors.accentGreen,
    WDColors.accentYellow,
  ];

  List<String> radarLegends = ["이번 달 평균", "전체 평균"];
  List<Color> radarMonthLegendsColor = [
    WDColors.primaryColor,
    WDColors.accentPurple,
  ];
  List<String> radarMonthLegends = ["이번 달 평균", "지난 달 평균"];
  List<Color> radarMonthLegendsLastColor = [
    WDColors.primaryColor,
    WDColors.accentGreen,
  ];

  // late Future<ChartDailyModel> _dailyChartData;
  // late Future<ChartWeeklyModel> _weeklyChartData;
  // late Future<ChartMonthlyModel> _monthlyChartData;
  //
  final ValueNotifier<bool> _loading = ValueNotifier(true);
  final ValueNotifier<ChartDailyModel?> _dailyChart = ValueNotifier(null);
  final ValueNotifier<ChartWeeklyModel?> _weekChart = ValueNotifier(null);
  final ValueNotifier<ChartMonthlyModel?> _monthChart = ValueNotifier(null);

  @override
  void initState() {
    GaUtil().trackScreen('ActivityChartPage', input: {'uuid': WDCommon().uuid});
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ChartDailyModel dailyResponse = await _requestDailyChart();
      ChartWeeklyModel weeklyResponse = await _requestWeeklyChart();
      ChartMonthlyModel monthlyResponse = await _requestMonthlyChart();
      setState(() {
        _dailyChart.value = dailyResponse;
        _weekChart.value = weeklyResponse;
        _monthChart.value = monthlyResponse;
        _loading.value = false;
      });
    });
    // _dailyChartData = _requestDailyChart();
  }

  void tabClick(int index) {
    setState(() {
      _tabIndex = index;
      // switch (index) {
      //   case 0:
      //     _dailyChartData = _requestDailyChart();
      //     break;
      //   case 1:
      //     _weeklyChartData = _requestWeeklyChart();
      //     break;
      //   case 2:
      //     _monthlyChartData = _requestMonthlyChart();
      //     break;
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;
    return PopScope(
      canPop: false,
      onPopInvoked: (_) {},
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: width,
        height: height,
        child: Stack(children: [
          SizedBox(
            width: width,
            height: height,
            child: Column(
              children: [
                _headerContents(),
                Expanded(
                    child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: _bodyContents(),
                )),
              ],
            ),
          ),
          ValueListenableBuilder(
              valueListenable: _loading,
              builder: (_, value, child) {
                return LoadingPage(isLoading: value);
              })
        ]),
      ),
    );
  }

  Future<ChartDailyModel> _requestDailyChart() async {
    // if (!_isLoading) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    // }
    Map<String, dynamic> body = {'uuid': WDCommon().uuid};

    final response = await WDApis().requestDailyChart(body);

    // setState(() {
    //   _isLoading = false;
    // });
    return response;
  }

  Future<ChartWeeklyModel> _requestWeeklyChart() async {
    // if (!_isLoading) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    // }
    Map<String, dynamic> body = {'uuid': WDCommon().uuid};
    final response = await WDApis().requestWeeklyChart(body);

    // setState(() {
    //   _isLoading = false;
    // });
    return response;
  }

  Future<ChartMonthlyModel> _requestMonthlyChart() async {
    // if (!_isLoading) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    // }
    Map<String, dynamic> body = {'uuid': WDCommon().uuid};
    final response = await WDApis().requestMonthlyChart(body);

    // setState(() {
    //   _isLoading = false;
    // });
    return response;
  }

  Widget _headerContents() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 40,
              height: 40,
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'assets/images/ic_btn_back.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ),
          const Text(
            '요약',
            style: TextStyle(
                color: WDColors.black2,
                fontWeight: FontWeight.w600,
                height: 1.4,
                fontSize: 18,
                fontFamily: 'pretendard'),
          ),
          const SizedBox(
            width: 40,
          ),
        ],
      ),
    );
  }

  Widget _bodyContents() {
    return Container(
        width: width,
        decoration: const BoxDecoration(color: WDColors.white),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 24),
              child: WD3TabBar(
                textList: const ['오늘', '이번 주', '한 달'],
                function: (idx) {
                  tabClick(idx);
                },
                width: width - 44,
                selectedIdx: _tabIndex,
              ),
            ),
            _tabContents()
          ],
        ));

    //_tabContents()
  }

  Widget _tabContents() {
    switch (_tabIndex) {
      case 0:
        return ValueListenableBuilder(
            valueListenable: _dailyChart,
            builder: (_, value, __) {
              if (value != null) {
                return _loadDailyChart(value);
              } else {
                return Container();
              }
            });
      // return FutureBuilder(
      //   future: _dailyChartData,
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData == false) {
      //       return Container();
      //     } else if (snapshot.hasError) {
      //       return Container();
      //     } else {
      //       return _loadDailyChart(snapshot.data!);
      //       // return Container();
      //     }
      //   },
      // );
      case 1:
        return ValueListenableBuilder(
            valueListenable: _weekChart,
            builder: (_, value, __) {
              if (value != null) {
                final bool isDummy =
                    _checkEmptyDataWeek(value.data.last_week_emotion) &&
                        _checkEmptyDataWeek(value.data.this_week_emotion);
                final bool moodDummy =
                    value.data.weekly_mood.where((e) => e.emotion != 0).isEmpty;
                final bool achievementDummy =
                    _weekAchievementDummy(value.data.this_week_data);
                bool weekDummy = (isDummy == false) &&
                    (moodDummy == false) &&
                    (achievementDummy == false);
                return _loadWeeklyChart(
                    value, isDummy, moodDummy, achievementDummy, weekDummy);
              } else {
                return Container();
              }
            });

      case 2:
        return ValueListenableBuilder(
            valueListenable: _monthChart,
            builder: (_, value, __) {
              if (value != null) {
                final bool isDummy =
                    _checkEmptyDataMonth(value.data.last_month_emotion) &&
                        _checkEmptyDataMonth(value.data.this_month_emotion);
                final bool categoryDummy = _checkCategoryEmpty(value);
                final bool moodDummy = value.data.monthly_mood
                    .where((e) => e.emotion != 0)
                    .isEmpty;
                final bool achievementDummy =
                    _monthAchievementDummy(value.data.this_month_data);
                final bool monthDummy = (isDummy == false) &&
                    (categoryDummy == false) &&
                    (moodDummy == false) &&
                    (achievementDummy == false);
                return _loadMonthlyChart(value, isDummy, categoryDummy,
                    moodDummy, achievementDummy, monthDummy);
              } else {
                return Container();
              }
            });
      default:
        return Container();
    }
  }

  Widget legendBuilder(List<String> labels, List<Color> labelColors) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 30, left: 33, right: 33),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
          border: Border.all(width: 1, color: Colors.grey[100]!),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(labels.length, (index) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: labelColors[index]),
                  ),
                ),
                Text(
                  labels[index],
                  style: AppTextStyles.body6(WDColors.black2)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ]);
        }),
      ),
    );
  }

  Widget _loadDailyChart(ChartDailyModel chartDailyModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 30, bottom: 12),
          child: Text("오늘의 달성률은?",
              textAlign: TextAlign.left,
              style: AppTextStyles.body1(WDColors.black)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AchieveRateSatis(
              achieveValue: (chartDailyModel.data.achievement * 100).toDouble(),
              staisValue: (chartDailyModel.data.progress * 100).toDouble()),
        ),
        const SizedBox(
          height: 40,
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child:
              Text('오늘의 활동별 감정 기록', style: AppTextStyles.body1(WDColors.black)),
        ),
        const SizedBox(
          height: 7,
        ),
        Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text('오늘 내 활동별 감정 기록을 시간별로 한 눈에 볼 수 있어요.',
                style: AppTextStyles.body6(WDColors.gray))),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 21, bottom: 3),
          child: Text(
            '일일 미션',
            style: Styler.style(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: WBActivityChart(
            data: chartDailyModel,
            isDaily: true,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 21, bottom: 3),
          child: Text(
            '주간 미션',
            style: Styler.style(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: WBActivityChart(
            data: chartDailyModel,
            isDaily: false,
          ),
        ),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }

  Widget _loadWeeklyChart(ChartWeeklyModel chartWeeklyModel, bool isDummy,
      bool moodDummy, bool achievementDummy, bool weekDummy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!weekDummy)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: WDNoDataGuide(),
          ),
        if (weekDummy)
          const SizedBox(
            height: 30,
          ),
        Container(
          margin: const EdgeInsets.only(left: 18),
          child:
              Text('이번 주 무드 트래커', style: AppTextStyles.body1(WDColors.black)),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
            margin: const EdgeInsets.only(left: 18),
            child: Text('이번 주 내 기분을 한 눈에 볼 수 있어요.',
                style: AppTextStyles.body6(WDColors.gray))),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 24),
          child: WDMoodChart(
            weeklyList: chartWeeklyModel.data.weekly_mood,
            moodDummy: moodDummy,
          ),
        ),
        const SizedBox(height: 60),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text('이번 주 달성률은?',
                      style: AppTextStyles.body1(WDColors.black)),
                ),
                // const SizedBox(
                //   height: 8,
                // ),
                // Container(
                //     margin: const EdgeInsets.only(left: 20),
                //     child: Text('지난 주와 비교하려면 토글을 클릭해보세요!',
                //         style: AppTextStyles.body6(WDColors.assitive))),
              ],
            ),
            // const Spacer(),
            // Row(
            //   children: [
            //     Text('지난 주', style: AppTextStyles.body6(WDColors.gray)),
            //     const SizedBox(
            //       width: 7,
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         setState(() => weekAchievement = !weekAchievement);
            //       },
            //       onPanEnd: (b) {
            //         setState(() => weekAchievement = !weekAchievement);
            //       },
            //       child: AnimatedContainer(
            //         height: 22,
            //         width: 42,
            //         padding: const EdgeInsets.all(3),
            //         alignment: weekAchievement
            //             ? Alignment.centerRight
            //             : Alignment.centerLeft,
            //         duration: const Duration(milliseconds: 300),
            //         curve: Curves.easeOut,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(50),
            //             color: !weekAchievement
            //                 ? const Color(0xFFC6C6C6)
            //                 : const Color(0xff41A7D7)),
            //         child: Container(
            //           width: 15,
            //           height: 15,
            //           decoration: BoxDecoration(
            //               shape: BoxShape.circle,
            //               color: WDColors.white,
            //               boxShadow: [
            //                 BoxShadow(
            //                     color: Colors.black.withOpacity(0.1),
            //                     spreadRadius: 1,
            //                     blurRadius: 0.2,
            //                     offset: const Offset(0, 1))
            //               ]),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 8,
            //     ),
            //   ],
            // )
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        WDAchievementLogChart(
          weekList: chartWeeklyModel.data.this_week_data,
          listEmpty: achievementDummy,
        ),
        const SizedBox(height: 60),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child:
              Text('내 감정비교 해볼까요?', style: AppTextStyles.body1(WDColors.black)),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('내 감정이 행동 전후로 어떻게 변화하였는지 지난 주와 이번 주를 비교해서 살펴보세요.',
                style: AppTextStyles.body6(WDColors.gray))),
        const SizedBox(
          height: 24,
        ),
        Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WDPieChart(
                      label: '지난 주',
                      weekEmotion: isDummy
                          ? _dummyLastWeek
                          : chartWeeklyModel.data.last_week_emotion,
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22),
                        child: Icon(
                          Icons.arrow_forward,
                        )),
                    WDPieChart(
                      label: '이번 주',
                      weekEmotion: isDummy
                          ? _dummyThisWeek
                          : chartWeeklyModel.data.this_week_emotion,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                WDEmotionLegend(),
              ],
            ),
            if (isDummy)
              Container(
                width: width,
                height: 230,
                color: WDColors.white.withOpacity(0.6),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Colors.white),
                    child: Text(
                      '활동을 진행하시면 내 데이터가 보여져요',
                      style:
                          Styler.style(color: WDColors.accentRed, height: 1.5),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(
          height: 70,
        ),
      ],
    );
  }

  final ValueNotifier<bool> _monthDummy = ValueNotifier(false);

  Widget _loadMonthlyChart(
      ChartMonthlyModel chartMonthlyModel,
      bool isDummy,
      bool categoryDummy,
      bool moodDummy,
      bool achievementDummy,
      bool monthDummy) {
    for (MonthDataModel e in chartMonthlyModel.data.this_month_data) {
      WDLog.e('data : ${e.toJson()}');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!monthDummy)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: WDNoDataGuide(),
          ),
        if (monthDummy)
          const SizedBox(
            height: 30,
          ),

        Container(
          margin: const EdgeInsets.only(left: 20),
          child:
              Text('이번 달 무드 트래커', style: AppTextStyles.body1(WDColors.black)),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text('이번 달 내 기분을 한 눈에 볼 수 있어요.',
                style: AppTextStyles.body6(WDColors.gray))),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: WDMoodChart(
              monthlyList: chartMonthlyModel.data.monthly_mood,
              moodDummy: moodDummy,
              isWeek: false),
          // child: MoodTrackerChart(
          //     loadIndex: _tabIndex,
          //     chartWeeklyModel: null,
          //     chartMonthlyModel: chartMonthlyModel),
        ),
        const SizedBox(height: 60),
        Row(
          children: [
            const SizedBox(
              width: 14,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Text('이번 달 달성률은?',
                      style: AppTextStyles.heading3(WDColors.black)),
                ),
                const SizedBox(
                  height: 7,
                ),
                // Container(
                //     margin: const EdgeInsets.only(left: 8),
                //     child: Text('지난 달과 비교하려면 토글을 클릭해보세요!',
                //         style: AppTextStyles.body6(WDColors.gray))),
              ],
            ),
            // const Spacer(),
            // Row(
            //   children: [
            //     Text('지난 달', style: AppTextStyles.body6(WDColors.gray)),
            //     const SizedBox(
            //       width: 7,
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         setState(() => monthAchievement = !monthAchievement);
            //       },
            //       onPanEnd: (b) {
            //         setState(() => monthAchievement = !monthAchievement);
            //       },
            //       child: AnimatedContainer(
            //         height: 22,
            //         width: 42,
            //         padding: const EdgeInsets.all(3),
            //         alignment: monthAchievement
            //             ? Alignment.centerRight
            //             : Alignment.centerLeft,
            //         duration: const Duration(milliseconds: 300),
            //         curve: Curves.easeOut,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(50),
            //             color: const Color(0xFFC6C6C6)),
            //         child: Container(
            //           width: 15,
            //           height: 15,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(100),
            //             color: WDColors.white,
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 8,
            //     ),
            //   ],
            // )
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        WDAchievementLogChart(
          monthList: chartMonthlyModel.data.this_month_data,
          listEmpty: achievementDummy,
          isWeek: false,
        ),
        const SizedBox(height: 60),
        Container(
          margin: const EdgeInsets.only(left: 18),
          child: Text('내 감정비교 해볼까요?',
              style: AppTextStyles.heading3(WDColors.black)),
        ),
        const SizedBox(
          height: 7,
        ),
        Container(
            margin: const EdgeInsets.only(left: 18),
            child: Text('내 감정이 행동 전후로 어떻게 변화하였는지 지난 달과 이번 달을 비교해서 살펴보세요.',
                style: AppTextStyles.body6(WDColors.gray))),
        const SizedBox(
          height: 24,
        ),
        Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WDPieChart(
                      label: '지난 달',
                      monthEmotion: isDummy
                          ? _dummyLastMonth
                          : chartMonthlyModel.data.last_month_emotion,
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22),
                        child: Icon(
                          Icons.arrow_forward,
                        )),
                    WDPieChart(
                      label: '이번 달',
                      monthEmotion: isDummy
                          ? _dummyThisMonth
                          : chartMonthlyModel.data.this_month_emotion,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                WDEmotionLegend(),
              ],
            ),
            if (isDummy)
              Container(
                width: width,
                height: 230,
                color: WDColors.white.withOpacity(0.6),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Colors.white),
                    child: Text(
                      '활동을 진행하시면 내 데이터가 보여져요',
                      style:
                          Styler.style(color: WDColors.accentRed, height: 1.5),
                    ),
                  ),
                ),
              ),
          ],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     WDPieChart(
        //       label: '지난 달',
        //       monthEmotion: chartMonthlyModel.data.last_month_emotion,
        //     ),
        //     const Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 22),
        //         child: Icon(
        //           Icons.arrow_forward,
        //         )),
        //     WDPieChart(
        //       label: '이번 달',
        //       monthEmotion: chartMonthlyModel.data.this_month_emotion,
        //     ),
        //   ],
        // ),
        // const SizedBox(
        //   height: 30,
        // ),
        // WDEmotionLegend(),
        const SizedBox(height: 70),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 18),
                  child: Text('카테고리별 변화',
                      style: AppTextStyles.heading3(WDColors.black)),
                ),
                const SizedBox(
                  height: 7,
                ),
                Container(
                    margin: const EdgeInsets.only(left: 18),
                    child: Text(
                        '나의 이번 달 평균과 이때까지의 평균을 비교해봐요.\n6개 카테고리별로 얼마나 달라졌을까요?',
                        style: AppTextStyles.body6(WDColors.gray))),
              ],
            ),
            const Spacer(),
            // Row(
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         setState(() => monthRadar = !monthRadar);
            //       },
            //       onPanEnd: (b) {
            //         setState(() => monthRadar = !monthRadar);
            //       },
            //       child: AnimatedContainer(
            //         height: 22,
            //         width: 42,
            //         padding: const EdgeInsets.all(3),
            //         alignment: monthRadar
            //             ? Alignment.centerRight
            //             : Alignment.centerLeft,
            //         duration: const Duration(milliseconds: 300),
            //         curve: Curves.easeOut,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(50),
            //             color: const Color(0xFFC6C6C6)),
            //         child: Container(
            //           width: 15,
            //           height: 15,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(100),
            //             color: WDColors.white,
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 8,
            //     ),
            //   ],
            // )
          ],
        ),
        Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: CategoricalRadarChart(
                      chartMonthlyModel: chartMonthlyModel,
                      lastStatus: monthRadar,
                      isDummy: categoryDummy),
                ),
                Center(
                  child: _radarLegned(),
                ),
              ],
            ),
            if (categoryDummy)
              Container(
                width: width,
                height: 450,
                color: WDColors.white.withOpacity(0.6),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 75),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: Colors.white),
                      child: Text(
                        '활동을 진행하시면 내 데이터가 보여져요',
                        style: Styler.style(
                            color: WDColors.accentRed, height: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 46),
      ],
    );
  }

  Widget _radarLegned() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 2,
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: WDColors.primaryColor),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '이번 달 평균',
                style: Styler.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                    color: WDColors.black2),
              )
            ],
          ),
          const SizedBox(
            width: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: WDColors.accentPurple),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '지난 달 평균',
                style: Styler.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                    color: WDColors.black2),
              )
            ],
          )
        ],
      ),
    );
  }

  bool _checkEmptyDataWeek(WeekEmotionModel input) {
    return input.positive + input.negative + input.same == 0;
  }

  bool _checkEmptyDataMonth(MonthEmotionModel input) {
    return input.positive + input.negative + input.same == 0;
  }

  final WeekEmotionModel _dummyLastWeek = WeekEmotionModel(45, 25, 30);
  final WeekEmotionModel _dummyThisWeek = WeekEmotionModel(60, 10, 30);

  final MonthEmotionModel _dummyLastMonth = MonthEmotionModel(45, 25, 30);
  final MonthEmotionModel _dummyThisMonth = MonthEmotionModel(60, 10, 30);

  bool _checkCategoryEmpty(ChartMonthlyModel input) {
    if (input.data.this_month_ba_category.food != 0) {
      return false;
    }
    if (input.data.this_month_ba_category.exercise != 0) {
      return false;
    }
    if (input.data.this_month_ba_category.emotion != 0) {
      return false;
    }
    if (input.data.this_month_ba_category.practice != 0) {
      return false;
    }
    if (input.data.this_month_ba_category.moderation != 0) {
      return false;
    }
    if (input.data.this_month_ba_category.cognition != 0) {
      return false;
    }
    if (input.data.last_month_ba_category.food != 0) {
      return false;
    }
    if (input.data.last_month_ba_category.exercise != 0) {
      return false;
    }
    if (input.data.last_month_ba_category.emotion != 0) {
      return false;
    }
    if (input.data.last_month_ba_category.practice != 0) {
      return false;
    }
    if (input.data.last_month_ba_category.moderation != 0) {
      return false;
    }
    if (input.data.last_month_ba_category.cognition != 0) {
      return false;
    }
    return true;
  }

  bool _weekAchievementDummy(List<WeekDataModel>? input) {
    return input?.where((e) => e.progress != 0).isNotEmpty == false ||
        input == null ||
        input.isEmpty == true;
  }

  bool _monthAchievementDummy(List<MonthDataModel>? input) {
    return input?.where((e) => e.progress != 0).isNotEmpty == false ||
        input == null ||
        input.isEmpty == true;
  }
}
