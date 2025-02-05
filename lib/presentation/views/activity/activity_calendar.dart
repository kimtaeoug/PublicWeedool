import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:weedool/controllers/activity/activity_controller.dart';
import 'package:weedool/extension/global_key_extension.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/utils/ui_util.dart';

class ActivityCalendar extends StatefulWidget {
  DateTime selectedDate;
  final Function(DateTime, DateTime) onDaySelected;
  final Function() todayFunction;
  final bool isWeek;

  ActivityCalendar(
      {super.key,
      required this.selectedDate,
      required this.onDaySelected,
      required this.todayFunction,
      this.isWeek = false});

  @override
  State<StatefulWidget> createState() => _ActivityCalendar();
}

class _ActivityCalendar extends State<ActivityCalendar> {
  bool isWeek = false;
  final DateTime _firstDate = DateTime.now().subtract(const Duration(days: 90));
  final DateTime _lastDate = DateTime.now();
  double _headerTitlePosition = 0;
  double _headerTitleWidth = 0;
  ActivityController controller = ActivityController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Size titleSize = UiUtil.textSize('990월', _headerTitleStyle);
      Offset _headerPosition = UiUtil.widgetPosition(_key) ?? Offset.zero;
      setState(() {
        _headerTitleWidth = titleSize.width;
        _headerTitlePosition = _headerPosition.dy;
      });
      // setState(() {
      //   // controller.closeOffset.value = closeOffsetKey.localPosition ?? Offset.zero;
      // });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final TextStyle _headerTitleStyle = Styler.style(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      fontSize: 18);

  final TextStyle _dayOfWeekStyle = Styler.style(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.5);
  final TextStyle _defaultTextStyle =
      Styler.style(color: Colors.white, fontSize: 15, letterSpacing: -0.5);
  final TextStyle _disableTextStyle = Styler.style(
      color: Colors.white.withOpacity(0.5), fontSize: 15, letterSpacing: -0.5);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Padding(
        padding: EdgeInsets.only(
            left: 13, right: 13, top: MediaQuery.of(context).padding.top),
        child: Stack(
          children: [
            TableCalendar(
              calendarFormat:
                  widget.isWeek ? CalendarFormat.week : CalendarFormat.month,
              onDaySelected: widget.onDaySelected,
              headerVisible: true,
              selectedDayPredicate: (date) =>
                  isSameDay(widget.selectedDate, date),
              daysOfWeekHeight: 64,
              rowHeight: 58,
              startingDayOfWeek: StartingDayOfWeek.monday,
              locale: 'ko_KR',
              focusedDay: widget.selectedDate,
              firstDay: _firstDate,
              lastDay: _lastDate,
              headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextFormatter: (date, locale) {
                    return '${DateFormat('MM').format(date)}월';
                  },
                  titleTextStyle: _headerTitleStyle,
                  headerMargin: const EdgeInsets.only(top: 10),
                  headerPadding: EdgeInsets.symmetric(
                      horizontal: (size.width - _headerTitleWidth) / 3),
                  formatButtonPadding: EdgeInsets.zero,
                  formatButtonVisible: false,
                  leftChevronMargin: EdgeInsets.zero,
                  leftChevronPadding: EdgeInsets.zero,
                  leftChevronIcon: _chevronIcon(isLeft: true),
                  rightChevronMargin: EdgeInsets.zero,
                  rightChevronPadding: EdgeInsets.zero,
                  rightChevronIcon: _chevronIcon(isLeft: false)),
              daysOfWeekStyle: DaysOfWeekStyle(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.white.withOpacity(0.5),
                              width: 0.5))),
                  weekdayStyle: _dayOfWeekStyle,
                  weekendStyle: _dayOfWeekStyle),
              calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  todayDecoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.circle),
                  cellMargin: const EdgeInsets.all(10),
                  cellPadding: EdgeInsets.zero,
                  cellAlignment: Alignment.center,
                  tablePadding: EdgeInsets.zero,
                  disabledTextStyle: _disableTextStyle,
                  selectedTextStyle: _defaultTextStyle,
                  outsideTextStyle: _disableTextStyle,
                  weekendTextStyle: _defaultTextStyle,
                  holidayTextStyle: _defaultTextStyle,
                  defaultTextStyle: _defaultTextStyle),
            ),
            Positioned(
                top: Platform.isAndroid ? _headerTitlePosition - 36 : 16.5,
                // top: 16.5,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    widget.todayFunction.call();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 4.5),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(1000)),
                        border: Border.all(color: Colors.white)),
                    child: Text(
                      '오늘',
                      style: Styler.style(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  final GlobalKey _key = GlobalKey();
  Widget _chevronIcon({bool isLeft = true}) {
    return Container(
      key: isLeft ? _key : null,
      width: 26,
      height: 26,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.white.withOpacity(0.3)),
      child: Center(
        child: RotatedBox(
          quarterTurns: isLeft ? 0 : 2,
          child: SizedBox(
            width: 6,
            child: Image.asset('assets/images/ic_chevron_right.png'),
          ),
        ),
      ),
    );
  }
}
