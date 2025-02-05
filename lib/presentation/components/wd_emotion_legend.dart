import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class WDEmotionLegend extends StatelessWidget {
  const WDEmotionLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34.5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 2,
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(3, (idx) => _item(idx)),
        ),
      ),
    );
  }

  Widget _item(int idx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: _whichColor(idx)),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          _whichText(idx),
          style: Styler.style(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              color: WDColors.black2),
        )
      ],
    );
  }

  Color _whichColor(int idx) {
    switch (idx) {
      case 0:
        return WDColors.primaryColor;
      case 1:
        return WDColors.accentGreen;
      case 2:
        return WDColors.accentYellow;
      default:
        return Colors.white;
    }
  }

  String _whichText(int idx) {
    switch (idx) {
      case 0:
        return '긍정적 변화';
      case 1:
        return '부정적 변화';
      case 2:
        return '유지';
      default:
        return '';
    }
  }
}
