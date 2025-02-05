import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/logger.dart';
import 'package:weedool/utils/text_style.dart';

class WdTimeChip extends StatelessWidget {
  final String text;
  final Color? color;
  final Function()? function;
  final Color? textColor;

  const WdTimeChip(
      {Key? key, required this.text, this.color, this.function, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (function != null) {
          function?.call();
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            color: color != null
                ? color!.withOpacity(0.1)
                : _whichColor().withOpacity(0.1)),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        child: Text(
          text,
          style: Styler.style(
            color: textColor ?? _whichColor(),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Color _whichColor() {
    switch (text) {
      case '아침':
        return WDColors.mint;
      case '점심':
        return WDColors.secondary800;
      case '저녁':
        return WDColors.primary600;
      case '무관':
        return WDColors.accentPurple;
      case '인지':
        return WDColors.recognitionColor;
      case '절제':
        return WDColors.moderationColor;
      case '운동':
        return WDColors.strongBlue;
      case '운동 및 신체활동':
        return WDColors.strongBlue;
      case '음식':
        return WDColors.accentOrange;
      case '정서':
        return WDColors.emotionColor;
      case '실천':
        return WDColors.accentGreen2;
      case '실천행동':
        return WDColors.accentGreen2;
      default:
        if(text.contains('취침')){
          return WDColors.primary600;
        }
        if(text.contains('식후')){
          return WDColors.mint;
        }
        if(text.contains('운동')){
          return WDColors.strongBlue;
        }
        return Colors.transparent;
    }
  }
}
