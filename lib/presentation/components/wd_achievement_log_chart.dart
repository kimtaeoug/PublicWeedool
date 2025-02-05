import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weedool/component/wd_dummy_guide.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/models/chart/model_chart_monthly.dart';
import 'package:weedool/models/chart/model_chart_weekly.dart';
import 'package:weedool/utils/logger.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/utils/time_util.dart';
import 'package:weedool/utils/ui_util.dart';

class WDAchievementLogChart extends StatefulWidget {
  List<WeekDataModel>? weekList;
  List<MonthDataModel>? monthList;
  final bool listEmpty;
  final bool isWeek;

  WDAchievementLogChart(
      {super.key,
      this.weekList,
      this.monthList,
      this.listEmpty = false,
      this.isWeek = true});

  @override
  State<StatefulWidget> createState() => _WDAchievementLogChart();
}

class _WDAchievementLogChart extends State<WDAchievementLogChart> {
  final double minY = 0;
  final double maxY = 100;
  final GlobalKey key = GlobalKey();
  double horizontalGap = 0;
  double _labelHeight = 0;

  List<WeekDataModel> _weekList = [];
  List<MonthDataModel> _monthList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double labelHeight = UiUtil.textSize('0', _xLabelStyle).height;
      Size? size = UiUtil.widgetSize(key);
      setState(() {
        if (widget.listEmpty) {
          if (widget.isWeek) {
            _weekList = _dummyWeekList;
          } else {
            _monthList = _dummyMonthList;
          }
        } else {
          if (widget.isWeek) {
            _weekList = widget.weekList ?? [];
          } else {
            _monthList = widget.monthList ?? [];
          }
        }
        _labelHeight = labelHeight;
        if (size != null) {
          horizontalGap =
              (size.height - (widget.weekList != null ? 60 : 60)) / 4 -
                  labelHeight;
        } else {
          horizontalGap = 23.89;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: size.width,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: _labelHeight),
              child: AspectRatio(
                aspectRatio: 15 / 9.5,
                child: BarChart(
                  key: key,
                  BarChartData(
                    barTouchData: BarTouchData(enabled: false),
                    backgroundColor: Colors.transparent,
                    barGroups: _weekList.isNotEmpty
                        ? _weekList
                            .map((e) => _convertData(DateTime.parse(e.date).day,
                                (e.progress * 100).toInt()))
                            .toList()
                        : _monthList
                            .map((e) => _convertData(
                                e.week, (e.progress * 100).toInt()))
                            .toList()
                            .reversed
                            .toList(),
                    minY: minY,
                    maxY: maxY,
                    gridData: FlGridData(
                        verticalInterval: 1,
                        horizontalInterval: 25,
                        getDrawingVerticalLine: (_) =>
                            const FlLine(color: Colors.transparent),
                        getDrawingHorizontalLine: (_) => const FlLine(
                            color: WDColors.grayBack, strokeWidth: 1)),
                    borderData: FlBorderData(
                        border: const Border(
                            top: BorderSide(color: WDColors.neutralLine),
                            bottom: BorderSide(color: WDColors.primaryColor),
                            left: BorderSide(color: Colors.transparent),
                            right: BorderSide(color: Colors.transparent))),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (idx, meta) {
                              if (_weekList.isNotEmpty) {
                                return _weekXLabel(idx.toInt());
                              } else {
                                return _monthLabel(idx.toInt());
                              }
                            },
                            reservedSize: _weekList != null ? 60 : 40),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      labelList.length,
                      (idx) => Padding(
                            padding: EdgeInsets.only(bottom: horizontalGap),
                            child: _xAxisLabel(labelList[idx]),
                          )),
                )),
            if (widget.listEmpty) WDDummyGuide(ratio: 15 / 9.5)
          ],
        ),
      ),
    );
  }

  final List<int> labelList = [100, 75, 50, 25];
  final TextStyle _xLabelStyle = Styler.style(
    color: WDColors.grayBack,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );

  Widget _xAxisLabel(int label) => Text(
        label.toString(),
        style: _xLabelStyle,
      );

  String _convertDate(int day) {
    if (_weekList.isNotEmpty) {
      return TimeUtil.convertDayOfWeekKorean(DateTime.parse(_weekList
          .where((e) => DateTime.parse(e.date).day == day)
          .first
          .date));
    } else {
      return '';
    }
  }

  Widget _weekXLabel(int idx) {
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          _weekList.isNotEmpty
              ? Text(
                  _convertDate(idx),
                  style: Styler.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.5),
                )
              : Container(),
          const SizedBox(
            height: 6,
          ),
          Text(
            idx.toString(),
            style: Styler.style(
                fontSize: 14, letterSpacing: -0.5, color: WDColors.gray),
          ),
        ],
      ),
    );
  }

  Widget _monthLabel(int idx) {
    return Padding(
      padding: const EdgeInsets.only(top: 19),
      child: Text(
        '$idx주전',
        style: Styler.style(
            fontWeight: FontWeight.w500, letterSpacing: -0.5, fontSize: 14),
      ),
    );
  }

  BarChartGroupData _convertData(int x, int y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
          fromY: 0,
          toY: y.toDouble(),
          gradient: WDColors.chartGradient,
          borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(0), top: Radius.circular(100)))
    ]);
  }

  final List<WeekDataModel> _dummyWeekList = [
    WeekDataModel('2024-07-06', 0.0, 0.5),
    WeekDataModel('2024-07-07', 0.0, 1.0),
    WeekDataModel('2024-07-08', 0.0, 0.4),
    WeekDataModel('2024-07-09', 0.0, 0.8),
    WeekDataModel('2024-07-10', 0.0, 0.6),
    WeekDataModel('2024-07-11', 0.0, 0.78),
    WeekDataModel('2024-07-12', 0.0, 0.4),
  ];
  final List<MonthDataModel> _dummyMonthList = [
    MonthDataModel(1, 0.0, 0.9),
    MonthDataModel(2, 0.0, 0.6),
    MonthDataModel(3, 0.0, 0.8),
    MonthDataModel(4, 0.0, 0.3),
  ];
}
