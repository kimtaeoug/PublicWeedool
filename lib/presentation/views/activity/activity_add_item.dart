import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/component/wd_time_chip.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class ActivityAddItem extends StatelessWidget {
  final String title;
  final List<String> time;
  final String activity;
  final String desc;
  final String imgPath;
  final bool isSelected;

  ActivityAddItem(
      {Key? key,
      required this.title,
      required this.time,
      required this.activity,
      required this.desc,
      required this.imgPath,
      this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width - 44,
      margin: const EdgeInsets.symmetric(horizontal: 22),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 1,
                offset: const Offset(0, 2))
          ],
          border: Border.all(
              color: isSelected ? WDColors.primaryColor : Colors.transparent)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Styler.style(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                        time.length,
                        (idx) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: WdTimeChip(
                                text: time[idx],
                              ),
                            )),
                  ),
                  Container(
                    width: 1.6,
                    height: 12,
                    decoration: const BoxDecoration(
                        color: WDColors.labelDisable,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  WdTimeChip(text: activity)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width - 52 - 44 - 40 - 20 - 2,
                child: Text(
                  desc,
                  style: Styler.style(
                      color: WDColors.gray800, fontSize: 13, height: 1.5),
                  maxLines: null,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              width: 52,
              height: 52,
              child: Image.network(
                imgPath,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}
