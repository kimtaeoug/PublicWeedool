import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class WdToast extends StatelessWidget {
  final String text;
  final bool isWrong;

  WdToast({Key? key, required this.text, this.isWrong = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: Container(
          width: width - 40,
          padding: const EdgeInsets.only(left: 19, top: 15, bottom: 15),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: isWrong ? WDColors.accentRed : WDColors.mint),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Image.asset(isWrong
                    ? 'assets/images/ic_error.png'
                    : 'assets/images/ic_info.png'),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(text,
                    style: Styler.style(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.46),
                    maxLines: null),
              ))
            ],
          ),
        ));
  }
}
