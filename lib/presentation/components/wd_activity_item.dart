import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/component/wd_time_chip.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class WDActivityItem extends StatelessWidget {
  final bool isDone;
  final String imgUrl;
  final List<String> timeTag;
  final String category;
  final String activity;

  const WDActivityItem(
      {super.key,
      required this.isDone,
      required this.imgUrl,
      required this.timeTag,
      required this.category,
      required this.activity});

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    final Size size = data.size;
    final double textScaleFactor =
        data.textScaleFactor > 1 ? data.textScaleFactor : 1;
    return Container(
      width: size.width,
      // height: 75,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 5.0,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 45,
                height: 45,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Image.network(
                        imgUrl,
                        // opacity: isDone
                        //     ? const AlwaysStoppedAnimation(0.5)
                        //     : const AlwaysStoppedAnimation(1.0),
                      ),
                    ),
                    if (isDone)
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.6)),
                        child: Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset('assets/images/ic_check.png'),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                            timeTag.length,
                            (idx) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: WdTimeChip(
                                    text: timeTag[idx],
                                  ),
                                )),
                      ),
                      Container(
                        width: 1.6 * textScaleFactor,
                        height: 12 * textScaleFactor,
                        decoration: const BoxDecoration(
                            color: WDColors.labelDisable,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      WdTimeChip(text: category)
                    ],
                  ),
                  SizedBox(
                    width: size.width - 140 - 7 * textScaleFactor,
                    child: Text(
                      activity,
                      style: isDone
                          ? Styler.style(
                              color: WDColors.alternative,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.5)
                          : Styler.style(
                              color: WDColors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.5),
                    ),
                  )
                ],
              ),
            ],
          ),
          Center(
            child: SizedBox(
              width: 7 * textScaleFactor,
              height: 12 * textScaleFactor,
              child: Image.asset(
                'assets/images/ic_chevron_right_gray.png',
              ),
            ),
          )
        ],
      ),
    );
  }
}
