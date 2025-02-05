import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_text_style.dart';

class BaCheckResultPop extends StatelessWidget {
  final List<String> doneList;
  final String title;
  final String subTitle;
  final String btnNegativeTxt;
  final String btnPositiveTxt;

  final Function negativeListener;
  final Function positiveListener;

  BaCheckResultPop(
      this.doneList,
      this.title,
      this.subTitle,
      this.btnNegativeTxt,
      this.btnPositiveTxt,
      this.negativeListener,
      this.positiveListener);

  String replaceStr(String value) {
    String res = '';

    switch (value) {
      case 'mon':
        res = '월';
        break;
      case 'tue':
        res = '화';
        break;
      case 'wen':
        res = '수';
        break;
      case 'thu':
        res = '목';
        break;
      case 'fri':
        res = '금';
        break;
      case 'sat':
        res = '토';
        break;
      case 'sun':
        res = '일';
        break;
      default:
        res = value;
        break;
    }

    return res;
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: Image.asset('assets/images/ic_check_ba_result_emotion.png',
                width: 100, height: 100, fit: BoxFit.contain),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading3(WDColors.black),
          ),
          const SizedBox(height: 4.0),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.body6(WDColors.gray),
          ),
          // doneList.isNotEmpty
          //     ? Container(
          //         margin: const EdgeInsets.only(top: 39),
          //         height: 94,
          //         child: Center(child: _addDoneDayItem()),
          //       )
          //     : const SizedBox(),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  negativeListener.call('aaa');
                },
                child: Container(
                  height: 52,
                  // margin: const EdgeInsets.only(right: 14),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0.5,
                            blurRadius: 6)
                      ]),
                  child: Center(
                      child: Text(
                    btnNegativeTxt,
                    style: AppTextStyles.body1(WDColors.black),
                  )),
                ),
              )),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  positiveListener.call('bbb');
                },
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF41A8D7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                      child: Text(btnPositiveTxt,
                          style: AppTextStyles.body1(WDColors.white))),
                ),
              ))
            ],
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.noScaling),
                child: dialogContent(context),
              )),
        ));
  }

  Widget _addDoneDayItem() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: doneList.length,
        itemBuilder: (BuildContext ctx, int idx) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 65,
            height: 94,
            child: Column(
              children: [
                SizedBox(
                  width: 65,
                  height: 67,
                  child: Stack(
                    children: [
                      Positioned(
                          right: 2,
                          bottom: 0,
                          child: Image.asset(
                              'assets/images/ic_ba_motion_back.png',
                              width: 53,
                              height: 53,
                              fit: BoxFit.fill)),
                      Positioned(
                          right: 0,
                          bottom: 6,
                          child: Image.asset(
                              'assets/images/ic_ba_check_done.png',
                              width: 17,
                              height: 17,
                              fit: BoxFit.fill)),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: Image.asset(
                              'assets/images/ic_ba_motion_done.png',
                              width: 63,
                              height: 63,
                              fit: BoxFit.fill))
                    ],
                  ),
                ),
                SizedBox(
                    width: 65,
                    height: 27,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(replaceStr(doneList[idx]),
                          textAlign: TextAlign.left,
                          style: AppTextStyles.body1(const Color(0xFF4A4A4A))),
                    ))
              ],
            ),
          );
        });
  }
}
