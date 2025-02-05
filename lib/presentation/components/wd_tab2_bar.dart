import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class WDTab2Bar extends StatelessWidget {
  final List<String> textList;

  final Function(int) function;
  final int selectedIdx;

  WDTab2Bar(
      {Key? key,
      required this.textList,
      required this.function,
      this.selectedIdx = 0})
      : super(key: key);

  final double _horizontalPadding = 38;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width - _horizontalPadding * 2,
      margin: EdgeInsets.symmetric(horizontal: _horizontalPadding),
      height: 50,
      child: Stack(
        children: [
          Container(
            width: size.width - _horizontalPadding * 2,
            height: 50,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: WDColors.grayBack),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                  textList.length, (idx) => _item(textList[idx], size, idx)),
            ),
          ),
          AnimatedAlign(
            alignment: _whichAlign(selectedIdx),
            duration: const Duration(milliseconds: 200),
            child: _item(textList[selectedIdx], size, selectedIdx,
                isSelected: true),
          )
        ],
      ),
    );
  }

  //grayBack
  Widget _item(String title, Size size, int idx, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        function.call(idx);
      },
      child: Container(
        width: (size.width - _horizontalPadding * 2) / 2 - 5,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: isSelected ? WDColors.strongBlue : Colors.transparent),
        child: Center(
          child: Text(
            title,
            style: isSelected ? _selectedStyle : _unSelectedStyle,
          ),
        ),
      ),
    );
  }

  AlignmentDirectional _whichAlign(int idx) {
    if (idx == 0) {
      return AlignmentDirectional.centerStart;
    } else {
      return AlignmentDirectional.centerEnd;
    }
  }

  final TextStyle _selectedStyle = Styler.style(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w600,
      height: 1.5);
  final TextStyle _unSelectedStyle = Styler.style(
      color: WDColors.assitive,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5);
}
