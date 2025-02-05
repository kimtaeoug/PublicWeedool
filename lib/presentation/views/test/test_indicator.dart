import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';

class TestIndicator extends StatelessWidget {
  final double value;

  TestIndicator({super.key, required this.value});

  //
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = (size.width - 66 >= 0) ? size.width - 66 : 0;
    return SizedBox(
      width: width,
      height: 8,
      child: Stack(
        children: [
          Container(
            width: width,
            height: 8,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: WDColors.disableToggleColor),
          ),
          Positioned(
              left: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: width * value,
                height: 8,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: WDColors.primaryColor),
              ))
        ],
      ),
    );
  }
}
