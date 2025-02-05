import 'package:flutter/cupertino.dart';
import 'package:weedool/component/wd_time_chip.dart';
import 'package:weedool/components/wd_colors.dart';

class ActivityTimeSlot extends StatelessWidget {
  ActivityTimeSlot({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_list.length, (idx) {
          _ActivityTimeSlotModel model = _list[idx];
          return Padding(
            padding: EdgeInsets.only(
              left: idx != _list.length ? 7 : 0,
            ),
            child: WdTimeChip(
                text: model.text,
                color: model.color,
                textColor: model.textColor),
          );
        }),
      ),
    );
  }

  final List<_ActivityTimeSlotModel> _list = [
    _ActivityTimeSlotModel('아침', WDColors.mint, WDColors.mint),
    _ActivityTimeSlotModel('점심', WDColors.secondary800, WDColors.secondary800),
    _ActivityTimeSlotModel('저녁', WDColors.primaryColor, WDColors.primaryColor),
    _ActivityTimeSlotModel('무관', WDColors.accentPurple, WDColors.accentPurple),
  ];
}

class _ActivityTimeSlotModel {
  final String text;
  final Color color;
  final Color textColor;

  _ActivityTimeSlotModel(this.text, this.color, this.textColor);
}
