import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/models/chart/model_chart_dmsls.dart';
import 'package:weedool/utils/logger.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/utils/ui_util.dart';

class WDPhysicalTestChart extends StatelessWidget {
  final List<Data> data;
  final double horizontalPadding;

  WDPhysicalTestChart(
      {super.key, required this.data, this.horizontalPadding = 20});

  final double minY = 0;
  final double maxY = 100;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = width * 335 / 524;
    final double yAxisLabelHeight =
        UiUtil.textSize('0', _yAxisLabelStyle).height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: yAxisLabelHeight),
              child: BarChart(
                BarChartData(
                  groupsSpace: 0,
                  backgroundColor: Colors.transparent,
                  barGroups: data.map((e) {
                    return _convertData(e.round, e.total_score);
                  }).toList(),
                  minY: minY,
                  maxY: maxY,
                  gridData: const FlGridData(show: false),
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
                            return _xAxisTitle(idx);
                          },
                          reservedSize: 50
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              child: SizedBox(
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      maxY.toInt().toString(),
                      style: _yAxisLabelStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Text(
                        minY.toInt().toString(),
                        style: _yAxisLabelStyle,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  final TextStyle _yAxisLabelStyle = Styler.style(
      color: WDColors.assitive, fontSize: 12, fontWeight: FontWeight.w500);

  String _checkDate(int idx) {
    return DateFormat('yy/MM/dd').format(DateTime.parse(
        data.where((e) => e.round == idx).first.timestamp));
  }

  Widget _xAxisTitle(double idx) {
    bool _isLatest = idx == data.length;
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            '${idx.toInt()}회차',
            style: Styler.style(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _isLatest ? WDColors.accentRed : Colors.black),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            _checkDate(idx.toInt()),
            style: Styler.style(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _isLatest ? WDColors.accentRed : WDColors.assitive,
            ),
          )
        ],
      ),
    );
  }

  BarChartGroupData _convertData(int x, int y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
          fromY: 0,
          toY: y.toDouble(),
          color: x == data.length ? WDColors.accentYellow : null,
          gradient: x == data.length ? null : WDColors.chartGradient,
          borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(0), top: Radius.circular(100)))
    ]);
  }
}
