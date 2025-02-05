import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class WD3TabBar extends StatelessWidget {
  final List<String> textList;

  final Function(int) function;
  final double width;
  final int selectedIdx;

  const WD3TabBar(
      {Key? key,
      required this.textList,
      required this.function,
      required this.width,
      this.selectedIdx = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
          color: WDColors.grayBack,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
                textList.length, (idx) => _item(idx, textList[idx])),
          ),
          AnimatedContainer(
            alignment: _witchAlignment(selectedIdx),
            duration: const Duration(milliseconds: 200),
            child: _item(selectedIdx, textList[selectedIdx], isSelected: true),
          )
        ],
      ),
    );
  }

  Alignment _witchAlignment(int index) {
    switch (index) {
      case 0:
        return Alignment.centerLeft;
      case 1:
        return Alignment.center;
      case 2:
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }

  Widget _item(int index, String text, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        function.call(index);
      },
      child: Container(
        width: width / 3,
        height: 32,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: isSelected ? WDColors.strongBlue : Colors.transparent),
        child: Center(
          child: Text(
            text,
            style: Styler.style(
                color: isSelected ? WDColors.white : WDColors.assitive,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
