import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/models/chart/model_chart_daily.dart';
import 'package:weedool/utils/time_util.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/utils/ui_util.dart';

class WBActivityChart extends StatefulWidget {
  final ChartDailyModel data;
  final bool isDaily;

  const WBActivityChart({super.key, required this.data, this.isDaily = true});

  @override
  State<StatefulWidget> createState() => _WBActivityChart();
}

class _WBActivityChart extends State<WBActivityChart> {
  bool startAnimation = false;
  double timeWidth = 0;
  Size xAxisLabelSize = Size(0, 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double _width = UiUtil.textSize('09:56', _timeStyle).width * 1.1;
      Size axisLabel = UiUtil.textSize('0', _xAxisLabelStyle);
      setState(() {
        timeWidth = _width;
        xAxisLabelSize = axisLabel;
        startAnimation = true;
      });
    });
  }

  int _maxValueIdx = 6;
  late final Size size = MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    final List<DataModel> list =
        widget.isDaily ? widget.data.data.daily : widget.data.data.weekly;
    final int length = list.length;
    if (list.isNotEmpty) {
      return SizedBox(
        width: size.width,
        // height: ((length * 45) + (13 * (length - 1)) + 5 + xAxisLabelSize.height)
        //     .toDouble(),
        child: Stack(
          children: [
            Positioned(
                top: 0,
                left: 69 + timeWidth - (xAxisLabelSize.width - 1),
                child: _xAxisLabel(list.length, size.width)),
            Padding(
              padding: EdgeInsets.only(top: xAxisLabelSize.height + 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                    list.length,
                    (idx) => Padding(
                          padding: EdgeInsets.only(
                              bottom: (idx + 1) == length ? 0 : 13),
                          child: _item(
                              list[idx].activity_id,
                              TimeUtil.convertDateToTime(list[idx].end_time),
                              list[idx].emotion ?? 0,
                              size.width),
                        )),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: size.width,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                left: 69 + timeWidth - (xAxisLabelSize.width - 1),
                child: _xAxisLabel(4, size.width)),
            Padding(
              padding: EdgeInsets.only(top: xAxisLabelSize.height + 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                    4,
                    (idx) => Padding(
                        padding: EdgeInsets.only(bottom: idx != 3 ? 13 : 0),
                        child: _dummyItem())),
              ),
            ),
          ],
        ),
      );
    }
  }

  //일일 미션 -> 요약 버튼

  LinearGradient get _dailyGradient => const LinearGradient(
        colors: [WDColors.primaryColor, WDColors.gradientMainColor3],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  LinearGradient get _weeklyGradient => const LinearGradient(
        colors: [WDColors.accentOrange, WDColors.fog],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  final TextStyle _timeStyle = Styler.style(
    color: WDColors.neutral,
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );

  double _convertWidth(double width, int value, String time) {
    return (width - 69 - timeWidth) * value / _maxValueIdx;
  }

  Widget _item(String imgUrl, String time, int value, double width) {
    double _timeWidth = timeWidth - xAxisLabelSize.width / 4 - 1;
    return SizedBox(
      width: size.width - 42,
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: WDColors.gallery),
            child: CachedNetworkImage(
              imageUrl:
                  'https://weedool-app-mvp.s3.ap-northeast-2.amazonaws.com/icon/ba/$imgUrl.png',
              width: 45,
              height: 45,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: _timeWidth >= 0 ? _timeWidth : 0,
              child: Text(
                time,
                style: _timeStyle,
              ),
            ),
          ),
          AnimatedContainer(
            width: startAnimation ? _convertWidth(width, value, time) : 0,
            height: 17,
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
                gradient: widget.isDaily ? _dailyGradient : _weeklyGradient,
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(100))),
          )
        ],
      ),
    );
  }

  Widget _dummyItem() {
    return Container(
      width: 45,
      height: 45,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: WDColors.gallery),
    );
  }

  final TextStyle _xAxisLabelStyle = Styler.style(
      color: WDColors.tabActivityChartBack,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5);

  Widget _xAxisLabel(int length, double totalWidth) {
    return SizedBox(
      width: size.width - (69 + timeWidth - (xAxisLabelSize.width - 1)) - 42,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_maxValueIdx, (idx) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                idx.toString(),
                style: _xAxisLabelStyle,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: 1,
                height: (length * 45) + (13 * (length + 1)),
                color: WDColors.tabActivityChartBack,
              )
            ],
          );
        }),
      ),
    );
  }
}
