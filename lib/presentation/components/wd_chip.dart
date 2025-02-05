import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class WdChip extends StatelessWidget {
  final String text;
  final Function()? function;
  final Color color;
  final EdgeInsets? padding;
  final bool isSelected;

  WdChip(
      {Key? key,
      required this.text,
      this.function,
      this.color = WDColors.primaryColor,
      this.padding,
      this.isSelected = false})
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
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            color: isSelected ? WDColors.primaryColor : Colors.white,
            border: Border.all(
                color: isSelected ? Colors.transparent : WDColors.neutral)),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Text(
          text,
          style: Styler.style(
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: isSelected ? Colors.white : WDColors.neutral),
        ),
      ),
    );
  }
}
