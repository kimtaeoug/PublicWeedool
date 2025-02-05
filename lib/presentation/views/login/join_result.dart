import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_text_style.dart';

import 'package:weedool/views/home.dart';
import 'package:weedool/views/test/intake_test_page.dart';

import 'login.dart';

class JoinResultView extends StatefulWidget {
  final String nick_name;

  const JoinResultView({Key? key, required this.nick_name}) : super(key: key);

  @override
  State<JoinResultView> createState() => _JoinResultState();
}

class _JoinResultState extends State<JoinResultView> {
  double height = 0;
  double width = 0;

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;
    return PopScope(
        canPop: false,
        onPopInvoked: (_) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginView()),
                  (_) => false);
        },
        child: _body());
  }

  Widget _body() {
    return Scaffold(
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: SafeArea(
        child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 116,
                    ),
                    Text("${widget.nick_name}님 \n회원가입을 축하합니다!",
                        textAlign: TextAlign.left,
                        style: AppTextStyles.heading1(WDColors.black)),
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text("이제 간단한 15문항의 검사만 남았어요!",
                            textAlign: TextAlign.left,
                            style: AppTextStyles.body2(WDColors.gray))),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 24),
                        child: Image.asset(
                            'assets/images/back_intake_result.gif',
                            width: 280,
                            height: 280,
                            fit: BoxFit.contain),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const IntakeTestPage(category: 'INTAKE')),
                          );
                        },
                        child: Container(
                            width: width,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: Color(0xFF41A7D7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Center(
                              child: Text("검사하러 가기",
                                  textAlign: TextAlign.left,
                                  style:
                                      AppTextStyles.heading3(WDColors.white)),
                            ))),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const HomeView(
                                        selectedIndex: 2,
                                      )),
                              (route) => false);
                        },
                        child: Container(
                            width: width,
                            height: 52,
                            decoration: BoxDecoration(
                              border: Border.all(color: WDColors.primaryColor),
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Center(
                              child: Text("나중에 하기",
                                  textAlign: TextAlign.left,
                                  style: AppTextStyles.heading3(
                                      WDColors.primaryColor)),
                            ))),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ],
            )),
      ),
    ));
  }
}
