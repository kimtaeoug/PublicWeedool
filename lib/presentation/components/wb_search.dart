import 'package:flutter/cupertino.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class WBSearch extends StatelessWidget {
  final double width;
  final Function() function;

  WBSearch({Key? key, required this.width, required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: function,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
              border: Border.all(color: WDColors.searchBoarder),
              color: WDColors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/ic_reserve_search.png',
                  width: 24, height: 24, fit: BoxFit.contain),
              Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text('상담센터 찾아볼까요',
                      textAlign: TextAlign.center,
                      style: Styler.style(
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        letterSpacing: -0.32,
                        color: WDColors.assitive,
                        fontSize: 15,
                      ))),
            ],
          ),
        ));
  }
}
