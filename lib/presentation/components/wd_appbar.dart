import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class WDAppbar extends StatelessWidget {
  final BuildContext buildContext;
  final Function()? function;
  final String? text;
  final String? title;

  const WDAppbar(
      {super.key,
      required this.buildContext,
      this.function,
      this.text,
      this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: () {
                    if (function != null) {
                      function?.call();
                    } else {
                      Navigator.pop(buildContext);
                    }
                  },
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/images/ic_btn_back.png'),
                  ),
                ),
                text != null
                    ? Text(
                        text ?? '',
                        style: Styler.style(
                            color: WDColors.black2,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            height: 1.4,
                            letterSpacing: -0.32),
                      )
                    : Container(),
                const SizedBox(
                  width: 24,
                )
              ],
            ),
          ),
        ),
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              title ?? '',
              style: Styler.style(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.3),
            ),
          )
      ],
    );
  }
}
