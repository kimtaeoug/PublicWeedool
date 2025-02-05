import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class WDDummyGuide extends StatelessWidget {
  final double ratio;

  const WDDummyGuide({super.key, required this.ratio});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AspectRatio(
      aspectRatio: ratio,
      child: Container(
        width: size.width,
        color: WDColors.white.withOpacity(0.6),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Colors.white),
            child: Text(
              '활동을 진행하시면 내 데이터가 보여져요',
              style: Styler.style(color: WDColors.accentRed, height: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
