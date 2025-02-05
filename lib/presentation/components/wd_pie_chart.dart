import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/models/chart/model_chart_monthly.dart';
import 'package:weedool/models/chart/model_chart_weekly.dart';
import 'package:weedool/utils/logger.dart';
import 'package:weedool/utils/text_style.dart';

class WDPieChart extends StatefulWidget {
  final WeekEmotionModel? weekEmotion;
  final MonthEmotionModel? monthEmotion;
  final String label;

  const WDPieChart(
      {super.key, this.weekEmotion, this.monthEmotion, required this.label});

  @override
  State<StatefulWidget> createState() => _WDPieChart();
}

class _WDPieChart extends State<WDPieChart> {
  List<PieChartSectionData> list = [];

  _EmotionOneItem item = _EmotionOneItem();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<PieChartSectionData> result = _convertToSectionData();
      setState(() {
        list = result;
      });
      if (list.length == 1) {
        setState(() {
          item =
              _EmotionOneItem(color: list.first.color, value: list.first.value);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _contents(),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              widget.label,
              style: Styler.style(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _contents() {
    if (list.isNotEmpty) {
      if (item.color != null) {
        return _oneItemCircle(item.color ?? WDColors.assitive);
      } else {
        return SizedBox(
            width: 120,
            height: 120,
            child: Transform.scale(
              scale: 1.5,
              child: PieChart(
                PieChartData(
                    sections: list, centerSpaceRadius: 0, sectionsSpace: 0),
              ),
            ));
      }
    } else {
      return _emptyCircle();
    }
  }

  final TextStyle _titleStyle = Styler.style(
    fontSize: 15 / 1.5,
    fontWeight: FontWeight.w600,
  );
  final TextStyle _bigTitleStyle = Styler.style(
      fontSize: 15 / 1.5, fontWeight: FontWeight.w600, color: Colors.white);

  final double radius = 40.0;

  List<PieChartSectionData> _convertToSectionData() {
    if (widget.weekEmotion != null) {
      List<PieChartSectionData> result = [];
      if (widget.weekEmotion!.positive +
              widget.weekEmotion!.negative +
              widget.weekEmotion!.same !=
          0) {
        int positive = widget.weekEmotion!.positive;
        int negative = widget.weekEmotion!.negative;
        int same = widget.weekEmotion!.same;
        int _biggestIdx = -1;
        if (positive > negative) {
          if (positive > same) {
            _biggestIdx = 0;
          } else if (positive < same) {
            _biggestIdx = 2;
          }
        } else {
          if (negative > same) {
            _biggestIdx = 1;
          } else if (negative < same) {
            _biggestIdx = 2;
          }
        }
        if (widget.weekEmotion!.positive != 0) {
          result.add(PieChartSectionData(
              value: widget.weekEmotion!.positive.toDouble(),
              radius: radius,
              title: widget.weekEmotion!.positive.toString(),
              titleStyle: _biggestIdx == 0 ? _bigTitleStyle : _titleStyle,
              color: _color(EmotionType.positive)));
        }
        if (widget.weekEmotion!.negative != 0) {
          result.add(PieChartSectionData(
              value: widget.weekEmotion!.negative.toDouble(),
              radius: radius,
              title: widget.weekEmotion!.negative.toString(),
              titleStyle: _biggestIdx == 1 ? _bigTitleStyle : _titleStyle,
              color: _color(EmotionType.negative)));
        }
        if (widget.weekEmotion!.same != 0) {
          result.add(PieChartSectionData(
              value: widget.weekEmotion!.same.toDouble(),
              radius: radius,
              title: widget.weekEmotion!.same.toString(),
              titleStyle: _biggestIdx == 2 ? _bigTitleStyle : _titleStyle,
              color: _color(EmotionType.same)));
        }
      }
      return result;
    } else if (widget.monthEmotion != null) {
      List<PieChartSectionData> result = [];

      if (widget.monthEmotion!.positive +
              widget.monthEmotion!.negative +
              widget.monthEmotion!.same !=
          0) {
        int positive = widget.monthEmotion!.positive;
        int negative = widget.monthEmotion!.negative;
        int same = widget.monthEmotion!.same;
        int _biggestIdx = -1;
        if (positive > negative) {
          if (positive > same) {
            _biggestIdx = 0;
          } else if (positive < same) {
            _biggestIdx = 2;
          }
        } else {
          if (negative > same) {
            _biggestIdx = 1;
          } else if (negative < same) {
            _biggestIdx = 2;
          }
        }
        if (positive != 0) {
          result.add(PieChartSectionData(
              value: widget.monthEmotion!.positive.toDouble(),
              radius: radius,
              title: widget.monthEmotion!.positive.toString(),
              titleStyle: _biggestIdx == 0 ? _bigTitleStyle : _titleStyle,
              color: _color(EmotionType.positive)));
        }
        if (negative != 0) {
          result.add(PieChartSectionData(
              value: widget.monthEmotion!.negative.toDouble(),
              radius: radius,
              title: widget.monthEmotion!.negative.toString(),
              titleStyle: _biggestIdx == 1 ? _bigTitleStyle : _titleStyle,
              color: _color(EmotionType.negative)));
        }
        if (same != 0) {
          result.add(PieChartSectionData(
              value: widget.monthEmotion!.same.toDouble(),
              radius: radius,
              title: widget.monthEmotion!.same.toString(),
              titleStyle: _biggestIdx == 2 ? _bigTitleStyle : _titleStyle,
              color: _color(EmotionType.same)));
        }
      }
      return result;
    } else {
      return [];
    }
  }

  Color _color(EmotionType type) {
    switch (type) {
      case EmotionType.positive:
        return WDColors.primaryColor;
      case EmotionType.negative:
        return WDColors.accentGreen;
      case EmotionType.same:
        return WDColors.accentYellow;
      default:
        return WDColors.assitive;
    }
  }

  Widget _emptyCircle() {
    return Container(
      width: 120,
      height: 120,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: WDColors.assitive),
      child: Center(
        child: Text(
          '없음',
          style: Styler.style(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _oneItemCircle(Color color) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: Text(
          '100',
          style: Styler.style(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}

enum EmotionType { positive, negative, same }

class _EmotionOneItem {
  Color? color;
  double? value;

  _EmotionOneItem({this.color, this.value});
}
