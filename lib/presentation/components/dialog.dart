import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weedool/component/wd_btn.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class WDDialog {
  ///
  /// 앱 종료 다이얼로그
  ///

  static void twoBtnDialog(
      BuildContext context,
      String title,
      String leftBtn,
      String rightBtn,
      Function(BuildContext context) leftFunction,
      Function(BuildContext context) rightFunction,
      {String? subTitle,
      Function(BuildContext context)? backFunction}) {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return PopScope(
              onPopInvoked: (_){},
              canPop: false,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                child: Dialog(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  backgroundColor: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: subTitle != null ? 20 : 45),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  style: Styler.style(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: WDColors.black2),
                                  textAlign: TextAlign.center,
                                ),
                                subTitle != null
                                    ? Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    subTitle,
                                    style: Styler.style(
                                      color: WDColors.alternative,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                leftFunction.call(dialogContext);
                              },
                              child: WDDialogLeftBtn(
                                width: 126,
                                text: leftBtn,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                rightFunction.call(dialogContext);
                              },
                              child: WDDialogRightBtn(
                                width: 126,
                                text: rightBtn,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  static void twoBtnImgDialog(
      BuildContext context,
      String title,
      String leftBtn,
      String rightBtn,
      Function(BuildContext) leftFunction,
      Function(BuildContext) rightFunction,
      String imgPath,
      {String? subTitle,
      Function(BuildContext)? backFunction}) {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return PopScope(
              onPopInvoked: (_){},
              canPop: false,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                child: Dialog(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  backgroundColor: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.asset(
                                'assets/images/ic_dlg_letter.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              title,
                              style: Styler.style(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            subTitle != null
                                ? Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                subTitle,
                                style: Styler.style(
                                    color: WDColors.alternative,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                            )
                                : Container()
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  leftFunction.call(dialogContext);
                                },
                                child: WDDialogLeftBtn(width: 126, text: leftBtn),
                              ),
                              GestureDetector(
                                onTap: () {
                                  rightFunction.call(dialogContext);
                                },
                                child:
                                WDDialogRightBtn(width: 126, text: rightBtn),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    //assets/images/ic_dlg_letter.png
                  ),
                ),
              ));
        });
  }
}
