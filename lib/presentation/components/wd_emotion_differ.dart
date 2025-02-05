import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/component/wd_dummy_guide.dart';
import 'package:weedool/component/wd_pie_chart.dart';
import 'package:weedool/models/chart/model_chart_monthly.dart';
import 'package:weedool/models/chart/model_chart_weekly.dart';
import 'package:weedool/utils/logger.dart';

class WdEmotionDiffer extends StatefulWidget {
  final WeekEmotionModel? lastWeekEmotion;
  final WeekEmotionModel? thisWeekEmotion;
  final MonthEmotionModel? lastMonthEmotion;
  final MonthEmotionModel? thisMonthEmotion;

  WdEmotionDiffer(
      {super.key,
      this.lastWeekEmotion,
      this.thisWeekEmotion,
      this.lastMonthEmotion,
      this.thisMonthEmotion});

  @override
  State<StatefulWidget> createState() => _WdEmotionDiffer();
}

class _WdEmotionDiffer extends State<WdEmotionDiffer> {
  WeekEmotionModel? _lastWeek = null;
  WeekEmotionModel? _thisWeek = null;

  MonthEmotionModel? _lastMonth = null;
  MonthEmotionModel? _thisMonth = null;

  bool isDummy = false;
  bool isWeek = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.lastWeekEmotion != null && widget.thisWeekEmotion != null) {
        if (_checkEmptyDataWeek(widget.lastWeekEmotion!) == true &&
            _checkEmptyDataWeek(widget.thisWeekEmotion!) == true) {
          setState(() {
            isDummy = true;
            _lastWeek = _dummyLastWeek;
            _thisWeek = _dummyThisWeek;
          });
        } else {
          setState(() {
            _lastWeek = widget.lastWeekEmotion;
            _thisWeek = widget.thisWeekEmotion;
          });
        }
      } else {
        if (_checkEmptyDataMonth(widget.lastMonthEmotion!) == true &&
            _checkEmptyDataMonth(widget.thisMonthEmotion!) == true) {
          setState(() {
            isWeek = false;
            isDummy = true;
            _lastMonth = _dummyLastMonth;
            _thisMonth = _dummyThisMonth;
          });
        } else {
          setState(() {
            isWeek = false;
            _lastMonth = widget.lastMonthEmotion;
            _thisMonth = widget.thisMonthEmotion;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WDPieChart(
                label: isWeek ? '지난 주' : '지난 달',
                weekEmotion: _lastWeek,
                monthEmotion: _lastMonth,
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: Icon(
                    Icons.arrow_forward,
                  )),
              WDPieChart(
                label: isWeek ? '이번 주' : '이번 달',
                weekEmotion: _thisWeek,
                monthEmotion: _thisMonth,
              ),
            ],
          ),
          if (isDummy) WDDummyGuide(ratio: 1)
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
}
