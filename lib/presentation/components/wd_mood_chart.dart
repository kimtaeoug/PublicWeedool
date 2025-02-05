import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/component/wd_dummy_guide.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/models/chart/model_chart_monthly.dart';
import 'package:weedool/models/chart/model_chart_weekly.dart';
import 'package:weedool/utils/logger.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/utils/time_util.dart';
import 'package:weedool/utils/ui_util.dart';

class WDMoodChart extends StatefulWidget {
  final List<WeeklyMoodModel>? weeklyList;
  final List<MonthlyMoodModel>? monthlyList;
  final Function()? function;
  final bool moodDummy;
  final bool isWeek;
  WDMoodChart(
      {super.key,
      this.weeklyList,
      this.monthlyList,
      this.function,
      this.moodDummy = false,
      this.isWeek = true});

  @override
  State<StatefulWidget> createState() => _WDMoodChart();
}

class _WDMoodChart extends State<WDMoodChart> {
  final GlobalKey key = GlobalKey();
  double horizontalGap = 0;
  bool isDataOne = false;

  bool loading = true;

  bool isDummy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isWeek) {
        _convertWeek();
      } else {
        _convertMonth();
      }
      Size? size = UiUtil.widgetSize(key);
      if (size != null) {
        setState(() {
          horizontalGap = (size.height - 10 - 70) / 4;
          loading = false;
        });
      } else {
        setState(() {
          horizontalGap = 37.5;
          loading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18, left: 20, right: 20),
            child: SizedBox(
              width: size.width,
              child: AspectRatio(
                aspectRatio: 15 / 10.5,
                child: Stack(
                  children: [
                    if (horizontalGap != 0)
                      SizedBox(
                          width: size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(
                                5,
                                (idx) => Padding(
                                      padding: EdgeInsets.only(
                                          top: idx == 0 ? 0 : horizontalGap),
                                      child: _horizontalLine(),
                                    )),
                          )),
                    Padding(
                      padding: const EdgeInsets.only(left: 48),
                      child: LineChart(
                        key: key,
                        LineChartData(
                            minY: 1,
                            maxY: 5,
                            lineTouchData: const LineTouchData(enabled: false),
                            backgroundColor: Colors.transparent,
                            borderData: FlBorderData(
                                border: Border(
                                    bottom: const BorderSide(
                                        color: WDColors.grayBack),
                                    top: const BorderSide(
                                        color: WDColors.grayBack),
                                    right: const BorderSide(
                                        color: WDColors.grayBack),
                                    left: BorderSide(
                                        color: widget.isWeek
                                            ? WDColors.grayBack
                                            : Colors.transparent))),
                            titlesData: FlTitlesData(
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(
                                  showTitles: false,
                                )),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (idx, meta) {
                                        try {
                                          if (idx == 0) {
                                            return Container();
                                          }
                                          if (widget.isWeek) {
                                            return _weekXLabel(idx.toInt());
                                          } else {
                                            return _monthXLabel(idx.toInt());
                                          }
                                        } catch (e) {
                                          return Container();
                                        }
                                      },
                                      interval: 1,
                                      reservedSize: 70),
                                )),
                            lineBarsData: [
                              LineChartBarData(
                                  show: false,
                                  spots: totalList,
                                  dotData: FlDotData(
                                    getDotPainter: (spot, _, data, __) =>
                                        FlDotCirclePainter(
                                            color: Colors.white,
                                            strokeColor: Colors.black,
                                            strokeWidth: 2),
                                  ),
                                  gradient: WDColors.chartGradient,
                                  barWidth: 5),
                              LineChartBarData(
                                  belowBarData: BarAreaData(
                                      gradient: WDColors.chartGradient),
                                  spots: valueList,
                                  dotData: FlDotData(
                                    getDotPainter: (spot, _, data, __) {
                                      if (isDataOne && spot.y == 1) {
                                        return FlDotCirclePainter(
                                            color: Colors.transparent,
                                            strokeWidth: 2,
                                            strokeColor: Colors.transparent);
                                      }
                                      return FlDotCirclePainter(
                                          color: Colors.white,
                                          strokeColor: Colors.black,
                                          strokeWidth: 2);
                                    },
                                  ),
                                  gradient: WDColors.chartGradient,
                                  barWidth: 5),
                            ],
                            gridData: FlGridData(
                                verticalInterval: 1,
                                horizontalInterval: 1,
                                getDrawingVerticalLine: (value) => FlLine(
                                    color: widget.isWeek
                                        ? WDColors.grayBack
                                        : Colors.transparent),
                                getDrawingHorizontalLine: (value) =>
                                    const FlLine(color: WDColors.grayBack))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (horizontalGap != 0)
            Positioned(
                top: 0,
                left: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (idx) => _emotionImg(idx)),
                )),
          if (isDummy) const WDDummyGuide(ratio: 15 / 10.5)
        ],
      ),
    );
  }

  //#F2F2F2

  Widget _horizontalLine() => Container(
        height: 2,
        color: WDColors.grayBack,
      );

  Widget _emotionImg(int idx) {
    return Padding(
      padding: EdgeInsets.only(
          left: 8,
          bottom: idx == 5
              ? 0
              : (horizontalGap - 34) >= 0
                  ? horizontalGap - 34
                  : 0),
      child: SizedBox(
        width: 36,
        height: 36,
        child: CircleAvatar(
          backgroundImage:
              AssetImage('assets/images/ic_mood_tracker_${idx + 1}.png'),
        ),
      ),
    );
  }

  String _convertDate(int day) {
    if (widget.isWeek) {
      return TimeUtil.convertDayOfWeek(widget.weeklyList!
          .where((e) => DateTime.parse(e.date).day == day)
          .first
          .day);
    } else {
      return '';
    }
  }
  String _dummyDay(int idx){
    switch(idx){
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '월';
    }
  }

  Widget _weekXLabel(int idx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          isDummy ? _dummyDay(idx) : _convertDate(idx),
          style: Styler.style(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.5),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          idx.toString(),
          style: Styler.style(
              fontSize: 14, letterSpacing: -0.5, color: WDColors.gray),
        ),
      ],
    );
  }

  Widget _monthXLabel(int idx) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        '$idx주차',
        style: Styler.style(
            color: WDColors.gray800,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.5),
      ),
    );
  }

  List<FlSpot> totalList = [];
  List<FlSpot> valueList = [];

  bool _checkWeekNotEmpty = false;

  void _convertWeek() {
    if (widget.weeklyList != null && (widget.weeklyList?.isNotEmpty == true)) {
      totalList.clear();
      valueList.clear();
      List<FlSpot> total = [];
      List<FlSpot> value = [];
      if (widget.moodDummy) {
        if (widget.function != null) {
          widget.function?.call();
        }
        setState(() {
          totalList = [
            FlSpot(1.0, 0.0),
            FlSpot(2.0, 0.0),
            FlSpot(3.0, 0.0),
            FlSpot(4.0, 0.0),
            FlSpot(5.0, 0.0),
            FlSpot(6.0, 0.0),
            FlSpot(7.0, 0.0)
          ];
          valueList = [
            FlSpot(1.0, 3.0),
            FlSpot(2.0, 1.0),
            FlSpot(4.0, 3.0),
            FlSpot(5.0, 4.0),
            FlSpot(6.0, 2.0),
            FlSpot(7.0, 1.0)
          ];
          isDummy = true;
        });
      } else {
        for (int idx = 0; idx < widget.weeklyList!.length; idx++) {
          WeeklyMoodModel data = widget.weeklyList![idx];
          double x = (DateTime.parse(data.date).day).toDouble();
          double y = (data.emotion).toDouble();
          total.add(FlSpot(x, y));
          if (y != 0) {
            value.add(FlSpot(x, y));
          }
        }
        setState(() {
          totalList = total;
          valueList = value;
          if (value.length == 1 && value.first.y != 1) {
            isDataOne = true;
            valueList.add(value.first.copyWith(y: 1));
          }
        });
      }
    }
  }

  bool _checkMonthNotEmpty = false;

  void _convertMonth() {
    if (widget.monthlyList != null &&
        (widget.monthlyList?.isNotEmpty == true)) {
      totalList.clear();
      valueList.clear();
      List<FlSpot> total = [];
      List<FlSpot> value = [];
      if (widget.moodDummy) {
        setState(() {
          totalList = [
            FlSpot(1.0, 0.0),
            FlSpot(2.0, 0.0),
            FlSpot(3.0, 0.0),
            FlSpot(4.0, 0.0)
          ];
          valueList = [
            FlSpot(1.0, 3.0),
            FlSpot(2.0, 2.0),
            FlSpot(3.0, 4.0),
            FlSpot(4.0, 1.0)
          ];
          isDummy = true;
        });
      } else {
        for (int idx = 0; idx < widget.monthlyList!.length; idx++) {
          MonthlyMoodModel data = widget.monthlyList![idx];
          double x = data.week.toDouble();
          double y = (data.emotion).toDouble();
          total.add(FlSpot(x, y));
          if (y != 0) {
            value.add(FlSpot(x, y));
          }
        }
        _checkMonthNotEmpty = value.where((e) => e.y != 0).isNotEmpty;
        setState(() {
          totalList = total;
          valueList = value;
          if (value.length == 1 && value.first.y != 1) {
            isDataOne = true;
            valueList.add(value.first.copyWith(y: 1));
          }
        });
      }
    }
  }
}
