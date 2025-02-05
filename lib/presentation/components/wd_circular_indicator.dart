import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:weedool/components/wd_colors.dart';

class WDCircularIndicator extends StatelessWidget {
  final double value;
  final double radius;
  final bool isAchievementRate;
  WDCircularIndicator(
      {super.key, required this.value, this.radius = 0, this.isAchievementRate = true});

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    _valueNotifier.value = value;
    return SizedBox(
      width: radius,
      height: radius,
      child: SimpleCircularProgressBar(
        progressStrokeWidth: isAchievementRate ? 12 : 10,
        backStrokeWidth: isAchievementRate ? 12 : 10,
        backColor: WDColors.gray300,
        progressColors: _progressColor(),
        valueNotifier: _valueNotifier,
      ),
    );
  }

  List<Color> _progressColor() {
    if (isAchievementRate) {
      return [
        WDColors.primaryColor,
        WDColors.accentGreen,
        WDColors.primaryColor,
      ];
    } else {
      return [
        WDColors.accentPurple2,
        WDColors.lightPurple,
        WDColors.accentPurple2,
      ];
    }
  }
}
