import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/component/wd_circular_indicator.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/utils/ui_util.dart';

///
/// 달성률, 만족도 Container
///

class AchieveRateSatis extends StatelessWidget {
  final double achieveValue;
  final double staisValue;
  final EdgeInsets? padding;

  AchieveRateSatis(
      {Key? key,
      required this.achieveValue,
      required this.staisValue,
      this.padding})
      : super(key: key);

  final TextStyle _valueStyle = Styler.style(
      color: WDColors.primary600,
      fontWeight: FontWeight.w800,
      fontSize: 24,
      letterSpacing: -0.5);

  @override
  Widget build(BuildContext context) {
    final double _valueWidth = UiUtil.textSize('100 %', _valueStyle).width;
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: padding ?? const EdgeInsets.only(left: 20, right: 40),
        height: 106,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(width: 1.2, color: const Color(0xFFececec)),
            color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Center(
                child: Stack(
                  children: [
                    Center(
                      child: WDCircularIndicator(
                        value: achieveValue,
                        radius: 50,
                      ),
                    ),
                    Center(
                      child: WDCircularIndicator(
                          value: staisValue,
                          radius: 25,
                          isAchievementRate: false),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: _valueWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '달성률',
                        style: Styler.style(
                          color: WDColors.primary600,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('${achieveValue.toInt()} %', style: _valueStyle)
                    ],
                  ),
                ),
                const SizedBox(
                  width: 21,
                ),
                SizedBox(
                  width: _valueWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '만족도',
                        style: Styler.style(
                          color: WDColors.accentPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('${staisValue.toInt()} %',
                          style: Styler.style(
                              color: WDColors.accentPurple,
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                              letterSpacing: -0.5))
                    ],
                  ),
                )
              ],
            )),
          ],
        ));
  }
}
