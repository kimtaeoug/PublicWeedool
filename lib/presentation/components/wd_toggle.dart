import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';

class WDToggle extends StatelessWidget {
  final Function() function;
  final bool isSelected;

  WDToggle({Key? key, required this.function, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: AnimatedContainer(
        width: 42,
        height: 22,
        padding: const EdgeInsets.symmetric(horizontal: 3.17, vertical: 2.75),
        alignment: !isSelected ? Alignment.centerRight : Alignment.centerLeft,
        duration: const Duration(microseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: !isSelected
              ? WDColors.disableToggleColor
              : WDColors.enableToggleColor,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        child: Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: WDColors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 0.2,
                    offset: const Offset(0, 1))
              ]),
        ),
      ),
    );
  }
}
