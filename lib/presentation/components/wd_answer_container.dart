import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class WDAnswerContainer extends StatelessWidget {
  final String text;
  final Function()? function;
  final double width;
  final bool isSelected;
  final double height;

  const WDAnswerContainer(
      {Key? key,
      required this.text,
      required this.function,
      required this.width,
      this.isSelected = false,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: function != null
            ? GestureDetector(
                onTap: () {
                  if (function != null) {
                    function?.call();
                  }
                },
                child: _item(),
              )
            : _item());
  }

  Widget _item() {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: isSelected ? 8 : 4,
                  )
                ]),
          ),
          Container(
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                color: isSelected
                    ? WDColors.primaryColor.withOpacity(0.1)
                    : Colors.white,
                border: Border.all(
                    color: isSelected
                        ? WDColors.primaryColor
                        : Colors.transparent)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: isSelected
                      ? Styler.style(
                          color: WDColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5)
                      : Styler.style(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: WDColors.assitive),
                ),
                !isSelected ? Container() : _checkBox()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _checkBox() => SizedBox(
        width: 24,
        height: 24,
        child: Image.asset(
          'assets/images/ic_checkbox_rounded.png',
          fit: BoxFit.cover,
        ),
      );
}
