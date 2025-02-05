import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_text_style.dart';

class CustomPop extends StatelessWidget {
  final int type;
  final String title;
  final String subTitle;
  final Widget assetImage;
  final String btnNegativeTxt;
  final String btnPositiveTxt;

  final Function negativeListener;
  final Function positiveListener;
  CustomPop(
      this.type,
      this.title,
      this.subTitle,
      this.assetImage,
      this.btnNegativeTxt,
      this.btnPositiveTxt,
      this.negativeListener,
      this.positiveListener);

  dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 40, left: 24, right: 24),
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
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading2(WDColors.black),
          ),
          subTitle == '' ? const SizedBox() : const SizedBox(height: 25.0),
          subTitle == ''
              ? const SizedBox()
              : Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body2(const Color(0xFF939393)),
                ),
          const SizedBox(height: 30.0),
          assetImage,
          const SizedBox(height: 30.0),
          type == 0
              ? Row(
                  children: [
                    Flexible(
                        flex: 10,
                        child: GestureDetector(
                          onTap: () {
                            negativeListener.call('aaa');
                          },
                          child: Container(
                            height: 62,
                            margin: const EdgeInsets.only(right: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB2B2B2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                                child: Text(btnNegativeTxt,
                                    style: AppTextStyles.heading3(
                                        WDColors.white))),
                          ),
                        )),
                    Flexible(
                      flex: 17,
                      child: GestureDetector(
                        onTap: () {
                          positiveListener.call('bbb');
                        },
                        child: Container(
                          height: 62,
                          decoration: BoxDecoration(
                            color: const Color(0xFF41A8D7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                              child: Text(btnPositiveTxt,
                                  style:
                                      AppTextStyles.heading3(WDColors.white))),
                        ),
                      ),
                    )
                  ],
                )
              : Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            negativeListener.call('aaa');
                          },
                          child: Container(
                            height: 62,
                            margin: const EdgeInsets.only(right: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF41A8D7),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                                child: Text(btnNegativeTxt,
                                    style: AppTextStyles.heading3(
                                        WDColors.white))),
                          ),
                        )),
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          positiveListener.call('bbb');
                        },
                        child: Container(
                          height: 62,
                          decoration: BoxDecoration(
                            color: const Color(0xFF41A8D7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                              child: Text(btnPositiveTxt,
                                  style:
                                      AppTextStyles.heading3(WDColors.white))),
                        ),
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: dialogContent(context),
        ));
  }
}

class CustomSimplePop extends StatelessWidget {
  final String title;
  final String subTitle;
  final String btnNegativeTxt;
  final String btnPositiveTxt;

  final Function negativeListener;
  final Function positiveListener;
  CustomSimplePop(this.title, this.subTitle, this.btnNegativeTxt,
      this.btnPositiveTxt, this.negativeListener, this.positiveListener);

  dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20, top: 30),
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
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading2(WDColors.black),
          ),
          const SizedBox(height: 8.0),
          Text(subTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.body2(
                const Color(0xFF939393),
              )),
          const SizedBox(height: 42.5),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      negativeListener.call('aaa');
                    },
                    child: Container(
                      height: 52,
                      margin: const EdgeInsets.only(right: 14),
                      decoration: BoxDecoration(
                        color: WDColors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: WDColors.shadowGray,
                            spreadRadius: 4,
                            blurRadius: 6,
                            offset: Offset(
                              0, 2, // changes position of shadow
                            ),
                          ),
                        ],
                        border: Border.all(
                            width: 1.2, color: const Color(0xFFececec)),
                      ),
                      child: Center(
                          child: Text(
                        btnNegativeTxt,
                        style: AppTextStyles.body1(WDColors.black),
                      )),
                    ),
                  )),
              Flexible(
                flex: 1,
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
                        child: Text(
                      btnPositiveTxt,
                      style: AppTextStyles.body1(WDColors.white),
                    )),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: dialogContent(context),
        ));
  }
}
