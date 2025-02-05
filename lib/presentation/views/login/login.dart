import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weedool/component/wd_btn.dart';
import 'package:weedool/component/wd_text_input.dart';

import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/controllers/login/controller_login.dart';
import 'package:weedool/utils/keyboard_util.dart';
import 'package:weedool/utils/preference_util.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/views/home.dart';
import 'package:weedool/views/loading_page.dart';
import 'package:weedool/views/login/terms.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginState();
}

class _LoginState extends State<LoginView> {
  double height = 0;
  double width = 0;

  LoginCtl loginCtl = LoginCtl();

  bool _emailNotEmpty = false;
  bool _checkPwdEmpty = false;

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;
    return PopScope(
      canPop: false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: _body(),
      ),
      onPopInvoked: (_) {},
    );
  }

  //      WidgetsBinding.instance.window.viewInsets.bottom > 0;
  Widget _body() {
    return Scaffold(
      backgroundColor: WDColors.backgroundColor,
      body: SizedBox(
        width: width,
        height: height,
        child: Stack(children: [
          SizedBox(
            width: width,
            height: height,
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  KeyboardUtil.closeKeyBoard();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top + 66,
                      ),
                      _title(),
                      const SizedBox(
                        height: 38,
                      ),
                      _email(),
                      const SizedBox(
                        height: 16,
                      ),
                      _pwd(),
                      const SizedBox(
                        height: 28,
                      ),
                      _register()
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              bottom: KeyboardUtil.keyboardOpen() ? 24 : 40,
              child: WDBtn(
                text: '로그인 하기',
                width: width - 40,
                height: 52,
                function: () {
                  if (_emailNotEmpty && _checkPwdEmpty) {
                    if (WDCommon().isValidEmailFormat(loginCtl.txtEmail)) {
                      _process();
                    } else {
                      WDCommon().toast(context, '이메일 형식이 아닙니다', isError: true);
                    }
                  } else {
                    if (!_emailNotEmpty) {
                      WDCommon().toast(context, '이메일을 입력해주세요', isError: true);
                      return;
                    }
                    if (!_checkPwdEmpty) {
                      WDCommon().toast(context, '비밀번호를 입력해주세요', isError: true);
                      return;
                    }
                  }
                },
                color: _emailNotEmpty && _checkPwdEmpty
                    ? WDColors.primaryColor
                    : WDColors.assitive,
              )),
          LoadingPage(isLoading: loginCtl.isLoading)
        ]),
      ),
    );
  }

  Widget _title() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          '로그인하기',
          style: Styler.style(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
      );

  Widget _email() {
    //
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: WDTextInput(
        label: '이메일',
        width: width,
        inputFormat: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
        controller: loginCtl.loginEmailTFController,
        keyboardInputType: TextInputType.emailAddress,
        onChanged: (value) {
          if (value != null) {
            loginCtl.txtEmail = value;
            if (value.isNotEmpty) {
              setState(() {
                _emailNotEmpty = true;
              });
            } else {
              setState(() {
                _emailNotEmpty = false;
              });
            }
          }
        },
        hintText: '이메일을 입력해주세요',
      ),
    );
  }

  final PreferenceUtil preferenceUtil = PreferenceUtil();

  Widget _register() {
    return Visibility(
        visible: !KeyboardUtil.keyboardOpen(),
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TermsView()));
            },
            child: Text(
              '회원가입하기',
              style: Styler.style(
                  fontSize: 15,
                  color: WDColors.neutral,
                  textDecoration: TextDecoration.underline),
            ),
          ),
        ));
  }

  Widget _pwd() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: WDTextInput(
        label: '비밀번호',
        width: width,
        inputFormat: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
        controller: loginCtl.loginPwdTFController,
        onChanged: (value) {
          if (value != null) {
            loginCtl.txtPwd = value;
            if (value.isNotEmpty) {
              setState(() {
                _checkPwdEmpty = true;
              });
            } else {
              if (_checkPwdEmpty == true) {
                setState(() {
                  _checkPwdEmpty = false;
                });
              }
            }
          }
        },
        showObscure: _checkPwdEmpty,
        isObscure: loginCtl.pwdStatus ? false : true,
        hintText: '비밀번호를 입력해주세요',
        obscureFunction: () {
          setState(() {
            loginCtl.pwdStatus = !loginCtl.pwdStatus;
          });
        },
      ),
    );
  }

  void _process() {
    if (!loginCtl.isLoading) {
      setState(() {
        loginCtl.isLoading = true;
      });
    }
    loginCtl.requestLogin().then((value) async {
      if (value.message == 'ok' && value.data?.error_code == 0) {
        if (value.data?.uuid != preferenceUtil.beforeUuid) {
          preferenceUtil.setCheckSleep(false);
          preferenceUtil.setCheckMood(false);
        }
        WDCommon().toast(context, '로그인에 성공하였습니다.');
        if (value.data!.error_code == 0) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString('uuid', value.data!.uuid!);
          WDCommon().uuid = value.data!.uuid!;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const HomeView(selectedIndex: 2)),
              (route) => false);
        }
      } else {
        if (value.data?.error_code == 1) {
          WDCommon()
              .toast(context, value.data?.result_msg ?? '', isError: true);
        } else {
          WDCommon().toast(context, value.message, isError: true);
        }
      }

      setState(() {
        loginCtl.isLoading = false;
      });
    });
  }
}
