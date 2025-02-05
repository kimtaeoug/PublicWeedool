import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_constants.dart';
import 'package:weedool/components/wd_text_style.dart';
import 'package:weedool/utils/ga_util.dart';
import 'package:weedool/views/chart/chart_activity.dart';
import 'package:weedool/views/chart/chart_dmsls.dart';

class TabChartView extends StatefulWidget {
  const TabChartView({Key? key}) : super(key: key);

  @override
  State<TabChartView> createState() => _TabChartState();
}

class _TabChartState extends State<TabChartView> {
  double height = 0;
  double width = 0;

  @override
  void initState() {
    GaUtil().trackScreen('ChartPage', input: {'uuid': WDCommon().uuid});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: Scaffold(
          backgroundColor: WDColors.backgroundColor,
          body: Column(
            children: [
              _headerContents(),
              _bodyContents(),
            ],
          ),
        ));
  }

  Widget _headerContents() {
    return Container(
      margin: EdgeInsets.only(top: 14 + MediaQuery.of(context).padding.top),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 34,
      width: width,
      child: Center(
        child: Text('요약',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading3(WDColors.black2)),
      ),
    );
  }

  Widget _bodyContents() {
    return Container(
        width: width,
        margin: const EdgeInsets.only(top: 67),
        height: height - heightHeader - heightBottomTab - 67,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _boxCharacter(),
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: _box1Area(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _box2Area(),
                ),
              ],
            )));
  }

  Widget _boxCharacter() {
    return SizedBox(
      height: 169,
      child: Image.asset('assets/images/character_chart.png',
          width: 169, height: 169, fit: BoxFit.contain),
    );
  }

  Widget _box1Area() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChartActivityView()),
        );
      },
      child: Container(
        width: width,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: WDColors.white,
          boxShadow: [
            BoxShadow(
                color: WDColors.gray.withOpacity(0.1),
                blurRadius: 0.5,
                spreadRadius: 0.5,
                offset: const Offset(0, 1))
          ],
        ),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/ic_chart_book.png',
                          width: 45, height: 39, fit: BoxFit.contain),
                      Container(
                        margin: const EdgeInsets.only(left: 11),
                        child: Text('내 행동 요약 보기',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.heading3(WDColors.black)),
                      )
                    ],
                  ),
                )),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                  margin: const EdgeInsets.only(right: 32),
                  child: Image.asset('assets/images/ic_chart_arrow_right.png',
                      width: 9, height: 13, fit: BoxFit.contain)),
            )
          ],
        ),
      ),
    );
  }

  Widget _box2Area() {
    return GestureDetector(
      onTap: () {
        if (WDCommon().dmsls_flag) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChartDmslsView()),
          );
        } else {
          WDCommon().toast(context, '심리검사를 완료해야 확인가능합니다.', isError: true);
        }
      },
      child: Container(
        width: width,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: WDColors.white,
          boxShadow: [
            BoxShadow(
                color: WDColors.gray.withOpacity(0.1),
                blurRadius: 0.5,
                spreadRadius: 0.5,
                offset: const Offset(0, 1))
          ],
        ),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/ic_chart_book.png',
                          width: 45, height: 39, fit: BoxFit.contain),
                      Container(
                        margin: const EdgeInsets.only(left: 11),
                        child: Text('심리검사 요약 보기',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.heading3(WDColors.black)),
                      )
                    ],
                  ),
                )),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                  margin: const EdgeInsets.only(right: 32),
                  child: Image.asset('assets/images/ic_chart_arrow_right.png',
                      width: 9, height: 13, fit: BoxFit.contain)),
            )
          ],
        ),
      ),
    );
  }

// Widget _box3Area() {
//   return InkWell(
//     onTap: () {
//       WDCommon().showToastWait();
//     },
//     child: Container(
//       margin: const EdgeInsets.only(top: 21),
//       width: width,
//       height: 77,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(15)),
//         color: WDColors.white,
//         boxShadow: [
//           BoxShadow(
//             color: WDColors.shadowGray,
//             spreadRadius: 2,
//             blurRadius: 4,
//             offset: Offset(
//               0, 2, // changes position of shadow
//             ),
//           )
//         ],
//       ),
//       child: Stack(
//         children: [
//           Align(
//               alignment: Alignment.centerLeft,
//               child: Container(
//                 margin: const EdgeInsets.only(left: 22),
//                 child: Row(
//                   children: [
//                     Image.asset('assets/images/ic_chart_book.png',
//                         width: 45, height: 39, fit: BoxFit.contain),
//                     Container(
//                       margin: const EdgeInsets.only(left: 11),
//                       child: const Text('그림검사 요약 보기',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: WDColors.black)),
//                     )
//                   ],
//                 ),
//               )),
//           Align(
//             alignment: Alignment.centerRight,
//             child: Container(
//                 margin: const EdgeInsets.only(right: 32),
//                 child: Image.asset('assets/images/ic_chart_arrow_right.png',
//                     width: 9, height: 13, fit: BoxFit.contain)),
//           )
//         ],
//       ),
//     ),
//   );
// }
}
