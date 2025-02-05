import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:weedool/component/achieve_rate_satis.dart';
import 'package:weedool/component/wd_activity_item.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/controllers/activity/activity_controller.dart';
import 'package:weedool/models/activity/model_activity_add.dart';
import 'package:weedool/models/activity/model_calendar_daily.dart';
import 'package:weedool/utils/ga_util.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/utils/time_util.dart';
import 'package:weedool/views/activity/activity_add.dart';
import 'package:weedool/views/activity/activity_calendar.dart';
import 'package:weedool/views/activity/activity_check_ba.dart';
import 'package:weedool/views/activity/activity_time_slot.dart';
import 'package:weedool/views/loading_page.dart';

class TabActivity2 extends StatefulWidget {
  const TabActivity2({super.key});

  @override
  State<StatefulWidget> createState() => _TabActivity2();
}

class _TabActivity2 extends State<TabActivity2> {
  final ActivityController _controller = ActivityController();
  final ValueNotifier<DailyCalendarModel?> _calendarModel = ValueNotifier(null);
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  late final Size size = MediaQuery.of(context).size;

  DateTime _selectedDate = DateTime.now();
  List<Activity> dailyList = [];
  List<Activity> weeklyList = [];
  bool isToday = true;
  bool showWeek = true;

  List<AddActivity> dailyAddList = [];
  List<AddActivity> weeklyAddList = [];
  final ValueNotifier<bool> _addLoading = ValueNotifier(false);

  @override
  void initState() {
    GaUtil().trackScreen('ActivityPage', input: {'uuid': WDCommon().uuid});
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _init();
      _setAddActivity();
    });
  }

  void _init() async {
    _loading.value = true;
    DailyCalendarModel response = await _controller.requestDaily(_selectedDate);
    setState(() {
      _calendarModel.value = response;
    });
    if (_calendarModel.value != null) {
      _setDailyWeekly(_calendarModel.value!);
    }
    _loading.value = false;
  }

  void _setAddActivity() async {
    setState(() {
      _addLoading.value = true;
    });
    List<AddActivity> dummyDailyList =
        await _controller.requestAddActivityList();
    List<AddActivity> dummyWeeklyList =
        await _controller.requestAddActivityList(type: 'weekly');
    setState(() {
      dailyAddList = dummyDailyList;
      weeklyAddList = dummyWeeklyList;
      _addLoading.value = false;
    });
  }

  void _setDailyWeekly(DailyCalendarModel input) {
    dailyList.clear();
    dailyList = [];
    weeklyList.clear();
    weeklyList = [];
    List<Activity> dummyDailyList = [];
    List<Activity> dummyWeeklyList = [];
    for (Activity activity in input.data.activity_list) {
      if (activity.activity_class == 'Weekly') {
        dummyWeeklyList.add(activity);
      } else {
        dummyDailyList.add(activity);
      }
    }
    setState(() {
      dailyList = dummyDailyList;
      weeklyList = dummyWeeklyList;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectDate, DateTime focusDate) async {
    _loading.value = true;
    setState(() {
      _selectedDate = selectDate;
    });
    DailyCalendarModel response = await _controller.requestDaily(_selectedDate);
    _setDailyWeekly(response);
    setState(() {
      _calendarModel.value = response;
      if (isSameDay(_selectedDate, DateTime.now())) {
        isToday = true;
      } else {
        isToday = false;
      }
    });
    _loading.value = false;
  }

  void _todayFunction() async {
    _loading.value = true;
    setState(() {
      _selectedDate = DateTime.now();
    });
    DailyCalendarModel response = await _controller.requestDaily(_selectedDate);
    _setDailyWeekly(response);
    setState(() {
      _calendarModel.value = response;
      isToday = true;
    });
    _loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false, onPopInvoked: (_) {}, child: _body());
  }

  Widget _body() {
    final MediaQueryData data = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Container(
              decoration:
                  const BoxDecoration(gradient: WDColors.calendarGradient),
              width: size.width,
              height: size.height,
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: TextScaler.noScaling),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ActivityCalendar(
                            selectedDate: _selectedDate,
                            onDaySelected: _onDaySelected,
                            todayFunction: _todayFunction,
                            isWeek: showWeek,
                          ),
                          _btn()
                        ],
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      width: size.width,
                      decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                          color: Colors.white),
                      child: ValueListenableBuilder(
                          valueListenable: _loading,
                          builder: (_, value, child) {
                            return value
                                ? const SizedBox(
                                    height: 200,
                                  )
                                : MediaQuery(
                                    data: data.copyWith(
                                        textScaler: data.textScaleFactor > 1
                                            ? null
                                            : TextScaler.noScaling),
                                    child: _contents());
                          }),
                    ),
                  )
                ],
              ),
            ),
            ValueListenableBuilder(
                valueListenable: _loading,
                builder: (_, value, child) {
                  return MediaQuery(
                    data: data.copyWith(textScaler: TextScaler.noScaling),
                    child: LoadingPage(isLoading: value),
                  );
                }),
            // ActivityCoachMark()
          ],
        ),
      ),
    );
  }

  Widget _btn() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showWeek = !showWeek;
        });
        // GaUtil().trackEvent('CalendarTypeEvent', parameter: {'type' : showWeek, 'uuid' : WDCommon().uuid});
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 14, bottom: 25, left: 12, right: 12),
          child: SizedBox(
            width: 13,
            height: 18,
            child: Image.asset(showWeek
                ? 'assets/images/ic_activity_arrow_bottom.png'
                : 'assets/images/ic_activity_arrow_top.png'),
          ),
        ),
      ),
    );
  }

  Widget _contents() {
    return ValueListenableBuilder(
        valueListenable: _calendarModel,
        builder: (_, value, child) {
          return Container(
            width: size.width,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isToday
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: ActivityTimeSlot(),
                      )
                    : dailyList.isNotEmpty || weeklyList.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _title(
                                    TimeUtil.convertDateToDetailKorean(
                                        _selectedDate),
                                    justToday: false),
                                const SizedBox(
                                  height: 21,
                                ),
                                achievementRateSatis(value!)
                              ],
                            ),
                          )
                        : Container(),
                if (dailyList.isEmpty && weeklyList.isEmpty) _empty(),
                _todayChallenge(dailyList),
                const SizedBox(
                  height: 30,
                ),
                _moreChallenge(weeklyList),
                const SizedBox(
                  height: 83 + 30,
                )
              ],
            ),
          );
        });
  }

  //오늘 이거 해봐요
  Widget _todayChallenge(List<Activity> input) {
    if (input.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(isToday ? '오늘 이거 꼭 해봐요!' : '일일 미션',
              justToday: isToday, input: input),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                  input.length,
                  (idx) => Padding(
                        padding: EdgeInsets.only(
                            bottom: idx != input.length ? 12 : 0),
                        child: _listItem(idx, input[idx]),
                      )),
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  //더 도전해볼까요?
  Widget _moreChallenge(List<Activity> input) {
    if (input.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(isToday ? '더 도전해볼까요?' : '주간 미션',
              justToday: isToday, isDaily: false, input: input),
          const SizedBox(
            height: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
                input.length,
                (idx) => Padding(
                      padding:
                          EdgeInsets.only(bottom: idx != input.length ? 12 : 0),
                      child: _listItem(idx, input[idx], isDaily: false),
                    )),
          )
        ],
      );
    } else {
      return Container();
    }
  }

  final TextStyle _titleStyle = Styler.style(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  //ic_activity_add
  Widget _title(String text,
      {bool justToday = true, bool isDaily = true, List<Activity>? input}) {
    if (!justToday) {
      return SizedBox(
        width: size.width,
        child: Text(text, style: _titleStyle, textAlign: TextAlign.start),
      );
    } else {
      return SizedBox(
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(text, style: _titleStyle, textAlign: TextAlign.start),
            if (_showAddBtn(isDaily, input ?? []))
              GestureDetector(
                onTap: () {
                  if (!_addLoading.value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivityAdd(
                              idx: isDaily ? 0 : 1,
                              dailyList: dailyAddList,
                              weeklyList: weeklyAddList,
                              isDailyFull: dailyList.length >= 7,
                              isWeeklyFull: weeklyList.length >= 7)),
                    );
                  } else {
                    WDCommon().toast(context, '잠시만 기다려주세요.', isError: true);
                  }
                },
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: Image.asset(
                    'assets/images/ic_activity_add.png',
                    fit: BoxFit.cover,
                  ),
                ),
              )
          ],
        ),
      );
    }
  }

  bool _showAddBtn(bool isDaily, List<Activity> input) {
    if (isDaily) {
      if (input.length >= 7) {
        return false;
      } else {
        return true;
      }
    } else {
      if (input.length >= 7) {
        return false;
      } else {
        return true;
      }
    }
  }

  //Achievement rate satisfaction
  Widget achievementRateSatis(DailyCalendarModel data) {
    return AchieveRateSatis(
        achieveValue: data.data.progress, staisValue: data.data.achievement);
  }

  final String _imgUrl =
      'https://weedool-app-mvp.s3.ap-northeast-2.amazonaws.com/icon/ba/';

  Widget _listItem(int idx, Activity activity, {bool isDaily = true}) {
    bool isDone = false;
    if (isDaily) {
      isDone = activity.state_daily;
    } else {
      if (activity.count == activity.act_done_days.length) {
        isDone = true;
      } else {
        isDone = activity.state_weekly;
      }
    }
    return GestureDetector(
      onTap: () {
        if (isToday && !isDone) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BaCheckView(
                        activity: activity,
                      )));
        }
      },
      child: WDActivityItem(
        isDone: isDone,
        imgUrl: '$_imgUrl${activity.activity_id}.png',
        timeTag: activity.time_tag,
        category: activity.category,
        activity: activity.activity,
      ),
    );
  }

  Widget _empty() {
    final MediaQueryData data = MediaQuery.of(context);
    return MediaQuery(
        data: data.copyWith(textScaler: TextScaler.noScaling),
        child: Container(
          width: size.width,
          padding: const EdgeInsets.only(top: 78, bottom: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/images/ic_main_motion3.png'),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                '아직 활동이 없어요!',
                style: Styler.style(
                    color: WDColors.neutral,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5),
              )
            ],
          ),
        ));
  }
}
