import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weedool/component/wd_appbar.dart';
import 'package:weedool/component/wd_btn.dart';
import 'package:weedool/component/wd_text_input.dart';

import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/controllers/login/controller_join.dart';
import 'package:weedool/models/login/data_join.dart';
import 'package:weedool/utils/keyboard_util.dart';
import 'package:weedool/utils/logger.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/views/loading_page.dart';
import 'package:weedool/views/login/member_info.dart';

class JoinView extends StatefulWidget {
  const JoinView({Key? key}) : super(key: key);

  @override
  State<JoinView> createState() => _JoinState();
}

class _JoinState extends State<JoinView> {
  double height = 0;
  double width = 0;

  JoinCtl joinCtl = JoinCtl();

  void setEmailState() {
    setState(() {
      joinCtl.BtnEnabledArr[joinCtl.pageIndex] = joinCtl.emailCheck &&
              (joinCtl.pwd.isNotEmpty) &&
              (joinCtl.pwd == joinCtl.pwd2)
          ? true
          : false;
    });
  }

  final FocusNode nameFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode phoneCheckFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameFocus.dispose();
    phoneFocus.dispose();
    phoneCheckFocus.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;
    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        _backProcess();
      },
      child: _body(),
    );
  }

  Widget _body() {
    return Scaffold(
      backgroundColor: WDColors.backgroundColor,
      body: MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: Stack(children: [
            SizedBox(
              width: width,
              height: height,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WDAppbar(
                      buildContext: context,
                      function: () {
                        _backProcess();
                      },
                    ),
                    Expanded(child: _bodyContents()),
                  ]),
            ),
            Positioned(
                bottom: KeyboardUtil.keyboardOpen() ? 24 : 40,
                child: WDBtn(
                  text: _btnText(),
                  width: width - 40,
                  height: 52,
                  function: () {
                    _checkFunction();
                  },
                  color: joinCtl.BtnEnabledArr[joinCtl.pageIndex]
                      ? WDColors.primaryColor
                      : WDColors.assitive,
                )),
            LoadingPage(isLoading: joinCtl.isLoading)
          ])),
    );
  }

  void _function() {
    if (joinCtl.BtnEnabledArr[joinCtl.pageIndex]) {
      if (joinCtl.pageIndex + 1 == joinCtl.BtnEnabledArr.length) {
        JoinData joinData = JoinData(joinCtl.nickName, joinCtl.email,
            joinCtl.name, joinCtl.phone, joinCtl.pwd);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MemberInfoView(joinData: joinData, joinProcess: true)));
      } else {
        setState(() {
          joinCtl.pageIndex++;
        });
        _pageController.animateToPage(joinCtl.pageIndex,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);
      }
    } else {
      WDLog.e('hey4');
    }
  }

  void _checkFunction() async {
    if (joinCtl.pageIndex == 1) {
      _phoneFunction();
    } else if (joinCtl.pageIndex == 2) {
      _certifyPhoneFunction();
    } else if (joinCtl.pageIndex == 3) {
      _checkEmail();
    } else if (joinCtl.pageIndex == 5) {
      _pwdCheckFunction();
      // _nickNameCheckFunction();
    } else if (joinCtl.pageIndex == 4) {
      _pwdFunction();
    } else if (joinCtl.pageIndex == 0) {
      _nameFunction();
    } else if(joinCtl.pageIndex == 6){
      _nickNameCheckFunction();
    } else{
      _function();
    }
  }

  //_certifyPhoneFunction();

  ValueNotifier<bool> _invokedBack = ValueNotifier(false);

  void _backProcess() {
    if (joinCtl.pageIndex == 0) {
      if (_invokedBack.value == false) {
        _invokedBack.value = true;
        joinCtl.clearData();
        Navigator.pop(context);
      }
    } else {
      if (joinCtl.pageIndex == 3) {
        setState(() {
          joinCtl.pageIndex = 1;
          joinCtl.certNum = '';
        });
      } else {
        setState(() {
          joinCtl.pageIndex--;
        });
      }
      _pageController.animateToPage(joinCtl.pageIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  String _title() {
    switch (joinCtl.pageIndex) {
      case 0:
        return '본인 확인을 위해\n이름을 입력해주세요.';
      case 1:
        return '전화번호를 입력해주세요.';
      case 2:
        return '받으신 인증번호를 입력해주세요';
      case 3:
        return '이메일을 입력해주세요';
      case 4:
        return '비밀번호를 입력해주세요';
      case 5:
        return '비밀번호를 다시 입력해주세요';
      case 6  :
        return '본인 확인을 위해\n이름을 입력해주세요.';
      default:
        return '본인 확인을 위해\n이름을 입력해주세요.';
    }
  }

  String _btnText() {
    switch (joinCtl.pageIndex) {
      case 0:
        return '다음';
      case 1:
        return '인증번호 발송';
      case 2:
        return '다음';
      case 3:
        return '다음';
      case 4:
        return '다음';
      case 5:
        return '다음';
      case 6:
        return '다음';
      default:
        return '다음';
    }
  }

  final PageController _pageController = PageController(initialPage: 0);

  Widget _bodyContents() {
    return PageView.builder(
      pageSnapping: false,
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      itemBuilder: (_, idx) {
        switch (idx) {
          // switch (joinCtl.pageIndex) {
          case 0:
            return _nameInputPage();
          case 1:
            return _phone();
          case 2:
            return _certifyPhone();
          case 3:
            return _email();
          case 4:
            return _pwd();
          case 5:
            return _pwdCheck();
          case 6:
            return _nickName();
          default:
            return Container();
        }
      },
      onPageChanged: (idx) {
        setState(() {
          joinCtl.pageIndex = idx;
        });
      },
    );
  }

  Widget _nameInputPage() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              _title(),
              style: Styler.style(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.3),
            ),
          ),
          WDTextInput(
            focusNode: nameFocus,
            width: width,
            controller: joinCtl.joinNameTFController,
            inputFormat: [
              _onlyKrEng,
              FilteringTextInputFormatter.deny(RegExp(r'\s'))
            ],
            maxLength: 10,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  joinCtl.name = value;
                  joinCtl.BtnEnabledArr[joinCtl.pageIndex] =
                      joinCtl.name.length <= 1 ? false : true;
                });
              }
            },
            //asd
            label: '이름',
            hintText: '이름을 입력해주세요',
            isError: showNameError,
            errorText: '이름을 2글자 이상 입력해주세요.',
            clearSuffix: showNameError
                ? joinCtl.name.isNotEmpty
                    ? _errorClearBtn(() {
                        setState(() {
                          joinCtl.name = '';
                          joinCtl.joinNameTFController.clear();
                          showNameError = false;
                          joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
                        });
                      })
                    : null
                : joinCtl.name.isNotEmpty
                    ? _clearBtn(() {
                        setState(() {
                          joinCtl.name = '';
                          joinCtl.joinNameTFController.clear();
                          joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
                        });
                      })
                    : null,
          )
        ],
      ),
    );
  }

  bool showNameError = false;

  void _nameFunction() {
    if (joinCtl.name.length <= 1) {
      setState(() {
        showNameError = true;
      });
      nameFocus.requestFocus();
    } else {
      setState(() {
        showNameError = false;
      });
      _function();
      if(KeyboardUtil.keyboardOpen()){
        KeyboardUtil.closeKeyBoard();
      }
    }
  }

  ///
  /// 전화번호 인증 관련
  /// 010-1111-1111 은 인증번호 111111으로 항상 pass
  ///

  // final MaskTextInputFormatter _phoneFilter = MaskTextInputFormatter( mask: '###-####-####', filter: {'#' : RegExp(r'^[0-9]$')});
  Widget _phone() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              _title(),
              style: Styler.style(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.3),
            ),
          ),
          WDTextInput(
            focusNode: phoneFocus,
            width: width,
            controller: joinCtl.joinPhoneTFController,
            keyboardInputType: TextInputType.phone,
            inputFormat: [
              FilteringTextInputFormatter.digitsOnly,
              FilteringTextInputFormatter.deny(RegExp(r'\s'))
            ],
            maxLength: 13,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  if (showPhoneError) {
                    showPhoneError = false;
                  }
                  joinCtl.phone = value;
                  joinCtl.certifyPhone.phone = value;
                  joinCtl.BtnEnabledArr[joinCtl.pageIndex] =
                      joinCtl.phone.isEmpty ? false : true;
                });
              }
            },
            label: '전화번호',
            hintText: '전화번호를 입력해주세요',
            isError: showPhoneError,
            errorText: '휴대폰번호 형식에 맞지 않습니다.',
            clearSuffix: showPhoneError
                ? joinCtl.phone.isNotEmpty
                    ? _errorClearBtn(() {
                        setState(() {
                          joinCtl.phone = '';
                          joinCtl.joinPhoneTFController.clear();
                          showPhoneError = false;
                          joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
                        });
                      })
                    : null
                : joinCtl.phone.isNotEmpty
                    ? _clearBtn(() {
                        setState(() {
                          joinCtl.phone = '';
                          joinCtl.joinPhoneTFController.clear();
                          joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
                        });
                      })
                    : null,
          ),
        ],
      ),
    );
  }

  bool showPhoneError = false;

  void _phoneFunction() async {
    try {
      if (WDCommon().isValidPhoneNumberFormat(joinCtl.phone)) {
        if (!joinCtl.isLoading) {
          setState(() {
            joinCtl.isLoading = true;
          });
        }
        joinCtl
            .requestCertPhoneSend(WDCommon().phoneFormatter(joinCtl.phone))
            .then((value) async {
          if (value.msg == 'ok') {
            WDCommon().toast(context, '인증번호가 발송되었습니다.');
            setState(() {
              showPhoneError = false;
              joinCtl.isLoading = false;
              joinCtl.certNum = '';
              joinCtl.BtnEnabledArr[2] = false;
            });
            joinCtl.joinCertTFController.clear();
            _function.call();
            if (KeyboardUtil.keyboardOpen()) {
              KeyboardUtil.closeKeyBoard();
            }
          } else {
            phoneFocus.requestFocus();
            setState(() {
              showPhoneError = true;
              joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
            });
            // WDCommon().toast(context, value.msg, isError: true);
          }
          setState(() {
            joinCtl.isLoading = false;
          });
        });
      } else {
        phoneFocus.requestFocus();
        setState(() {
          showPhoneError = true;
          joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
        });
      }
    } catch (e) {
      setState(() {
        joinCtl.isLoading = false;
      });
      WDCommon().toast(context, '에러가 발생했습니다.', isError: true);
    }
  }

  final GlobalKey _certifyKey = GlobalKey();

  Widget _certifyPhone() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (KeyboardUtil.keyboardOpen()) {
                KeyboardUtil.closeKeyBoard();
              }
            },
            child: Container(
              width: width,
              height: 40,
              color: Colors.transparent,
            ),
          ),
          Text(
            _title(),
            style: Styler.style(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                height: 1.3),
          ),
          const SizedBox(height: 30,),
          Container(
            key: _certifyKey,
            child: WDTextInput(
              focusNode: phoneCheckFocus,
              width: width,
              controller: joinCtl.joinCertTFController,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    if (_showPhoneCheckError) {
                      _showPhoneCheckError = false;
                    }
                    joinCtl.certNum = value;
                    joinCtl.BtnEnabledArr[joinCtl.pageIndex] =
                    joinCtl.certNum.isEmpty ? false : true;
                  });
                }
              },
              label: '인증번호',
              hintText: '인증번호를 입력해주세요',
              isError: _showPhoneCheckError,
              errorText: '인증번호가 일치하지 않습니다!',
              clearSuffix: _showPhoneCheckError
                  ? joinCtl.certNum.isNotEmpty
                  ? _errorClearBtn(() {
                setState(() {
                  _showPhoneCheckError = false;
                  joinCtl.certNum = '';
                  joinCtl.joinCertTFController.clear();
                  joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
                });
              })
                  : null
                  : joinCtl.certNum.isNotEmpty
                  ? _clearBtn(() {
                setState(() {
                  joinCtl.certNum = '';
                  joinCtl.joinCertTFController.clear();
                  joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
                });
              })
                  : null,
            ),
          )
        ],
      ),
    );
  }

  bool _showPhoneCheckError = false;

  void _certifyPhoneFunction() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!joinCtl.isLoading) {
      setState(() {
        joinCtl.isLoading = true;
      });
    }
    try {
      joinCtl
          .requestCertPhoneCheck(
              WDCommon().phoneFormatter(joinCtl.phone), joinCtl.certNum)
          .then((value) {
        if (value.msg == 'ok') {
          WDCommon().toast(context, '인증완료되었습니다.');
          setState(() {
            _showPhoneCheckError = false;
            joinCtl.BtnEnabledArr[joinCtl.pageIndex] = true;
            joinCtl.isLoading = false;
          });
          _function();
        } else {
          phoneCheckFocus.requestFocus();
          setState(() {
            _showPhoneCheckError = true;
            joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
          });
        }
        setState(() {
          joinCtl.isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        joinCtl.isLoading = false;
      });
      WDCommon().toast(context, '에러가 발생했습니다.', isError: true);
    }
  }

  bool _wrongEmailType = false;

  void _checkEmail() async {
    if (joinCtl.email.isEmpty) {
      WDCommon().toast(context, '이메일을 입력해주세요.', isError: true);
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    if (WDCommon().isValidEmailFormat(joinCtl.email)) {
      if (!joinCtl.isLoading) {
        setState(() {
          joinCtl.isLoading = true;
        });
      }
      joinCtl.requestCheckEmail(joinCtl.email).then((value) {
        if (value.message == 'ok') {
          if (value.data?.error_code != 1) {
            WDCommon().toast(context, '이메일 인증에 성공했습니다.');
            setState(() {
              joinCtl.emailCheck = value.data!.error_code == 0 ? true : false;
              setEmailState();
              showEmailError = false;
              joinCtl.isLoading = false;
              joinCtl.BtnEnabledArr[joinCtl.pageIndex] = true;
            });
            _function();
          } else {
            emailFocus.requestFocus();
            setState(() {
              showEmailError = true;
              joinCtl.emailCheck = false;
              setEmailState();
              joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
            });
            // WDCommon()
            //     .toast(context, value.data!.result_msg ?? '', isError: true);
          }
        } else {
          // WDCommon().toast(context, value.message, isError: true);
          emailFocus.requestFocus();
          setState(() {
            showEmailError = true;
            joinCtl.emailCheck = false;
            setEmailState();
            joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
          });
        }
        setState(() {
          joinCtl.isLoading = false;
        });
      });
    } else {
      emailFocus.requestFocus();
      setState(() {
        showEmailError = true;
        joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
        _wrongEmailType = true;
      });
      // WDCommon().toast(context, '이메일 형식에 맞지 않습니다.', isError: true);
    }
  }

  bool showEmailError = false;

  Widget _email() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              _title(),
              style: Styler.style(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.3),
            ),
          ),
          WDTextInput(
            focusNode: emailFocus,
            inputFormat: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            keyboardInputType: TextInputType.emailAddress,
            width: width,
            controller: joinCtl.joinEmailTFController,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  if (showEmailError) {
                    showEmailError = false;
                  }
                  joinCtl.email = value;
                  joinCtl.BtnEnabledArr[joinCtl.pageIndex] =
                      joinCtl.email.isEmpty ? false : true;
                });
              }
            },
            label: '이메일',
            hintText: '이메일을 입력해주세요.',
            isError: showEmailError,
            //
            errorText:
                _wrongEmailType ? '이메일 형식에 맞지 않습니다.' : '이미 사용 중인 이메일입니다.',
            clearSuffix: showEmailError
                ? joinCtl.email.isNotEmpty
                    ? _errorClearBtn(() {
                        joinCtl.joinEmailTFController.clear();
                        setState(() {
                          joinCtl.email = '';
                          showEmailError = false;
                          joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
                        });
                      })
                    : null
                : joinCtl.email.isNotEmpty
                    ? _clearBtn(() {
                        joinCtl.joinEmailTFController.clear();
                        setState(() {
                          joinCtl.email = '';
                          joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
                        });
                      })
                    : null,
          )
        ],
      ),
    );
  }

  Widget _pwd() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              _title(),
              style: Styler.style(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.3),
            ),
          ),
          WDTextInput(
            width: width,
            controller: joinCtl.joinPwdTFController,
            inputFormat: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  joinCtl.pwd = value;
                  checkLengthPwd = wdCommon.check8To16Character(value);
                  checkEnPwd = wdCommon.hasEn(value);
                  checkNumberPwd = wdCommon.hasNumber(value);
                  checkSpecialPwd = wdCommon.hasSpecialCharacter(value);
                });
                if (checkLengthPwd &&
                    checkEnPwd &&
                    checkNumberPwd &&
                    checkSpecialPwd) {
                  setState(() {
                    joinCtl.BtnEnabledArr[joinCtl.pageIndex] = true;
                  });
                  // setEmailState();
                }else{
                  setState(() {
                    joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
                  });
                }
              }
            },
            label: '비밀번호',
            hintText: '비밀번호를 입력해주세요',
            maxLength: 16,
            isObscure: !joinCtl.pwdStatus,
            showObscure: joinCtl.joinPwdTFController.text.isNotEmpty,
            obscureFunction: () {
              setState(() {
                joinCtl.pwdStatus = !joinCtl.pwdStatus;
              });
            },
            isError: joinCtl.pwd.isNotEmpty
                ? !(checkLengthPwd &&
                    checkEnPwd &&
                    checkNumberPwd &&
                    checkSpecialPwd)
                : false,
            errorWidget: _pwdErrorWidget(),
          ),
        ],
      ),
    );
  }

  final TextStyle _rightStyle =
      Styler.style(fontSize: 12, height: 1.5, color: Colors.black);
  final TextStyle _errorStyle =
      Styler.style(fontSize: 12, height: 1.5, color: WDColors.accentRed);

  final WDCommon wdCommon = WDCommon();

  bool checkLengthPwd = false;
  bool checkEnPwd = false;
  bool checkNumberPwd = false;
  bool checkSpecialPwd = false;

  Widget _pwdErrorWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Text.rich(TextSpan(children: [
        TextSpan(
            text: '8-16 글자, ',
            style: checkLengthPwd ? _rightStyle : _errorStyle),
        TextSpan(text: '영문, ', style: checkEnPwd ? _rightStyle : _errorStyle),
        TextSpan(
            text: '숫자, ', style: checkNumberPwd ? _rightStyle : _errorStyle),
        TextSpan(
            text: '특수문자', style: checkSpecialPwd ? _rightStyle : _errorStyle)
      ])),
    );
  }

  bool _showPwdError = false;
  bool _showPwd2Error = false;

  void _pwdFunction() {
    if (!(checkLengthPwd && checkEnPwd && checkNumberPwd && checkSpecialPwd)) {
      setState(() {
        _showPwdError = true;
      });
      return;
    } else {
      setState(() {
        _showPwdError = false;
      });
      _function();
      if(KeyboardUtil.keyboardOpen()){
        KeyboardUtil.closeKeyBoard();
      }
      if(joinCtl.joinPwdCheckTFController.text.isNotEmpty){
        if(joinCtl.pwd != joinCtl.pwd2){
          setState(() {
            joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
          });
        }
      }
    }
  }
  Widget _pwdCheck() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              _title(),
              style: Styler.style(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: WDTextInput(
              width: width,
              controller: joinCtl.joinPwdCheckTFController,
              inputFormat: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    joinCtl.pwd2 = value;
                  });
                  setEmailState();
                }
              },
              label: '비밀번호 확인',
              hintText: '비밀번호를 다시 입력해주세요',
              isObscure: !joinCtl.pwdStatus2,
              showObscure: joinCtl.joinPwdCheckTFController.text.isNotEmpty,
              obscureFunction: () {
                setState(() {
                  joinCtl.pwdStatus2 = !joinCtl.pwdStatus2;
                });
              },
              isError:
              joinCtl.pwd2.isNotEmpty ? joinCtl.pwd != joinCtl.pwd2 : false,
              errorText: '비밀번호가 다릅니다.',
            ),
          ),
        ],
      ),
    );
  }
  void _pwdCheckFunction(){
    if (joinCtl.pwd != joinCtl.pwd2) {
      setState(() {
        _showPwd2Error = true;
      });
    } else {
      setState(() {
        _showPwd2Error = false;
      });
      _function();
      if(KeyboardUtil.keyboardOpen()){
        KeyboardUtil.closeKeyBoard();
      }
    }
  }



  Widget _nickName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              _title(),
              style: Styler.style(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.3),
            ),
          ),
          WDTextInput(
            width: width,
            controller: joinCtl.joinNicknameTFController,
            inputFormat: [
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
              _onlyKrEng
            ],
            maxLength: 10,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  joinCtl.nickName = value;
                  joinCtl.BtnEnabledArr[joinCtl.pageIndex] =
                      joinCtl.nickName.length <= 1 ? false : true;
                });
              }
            },
            label: '닉네임',
            hintText: '닉네임을 입력해주세요.',
            isError: showNickNameError,
            errorText: '중복된 닉네임입니다.',
            clearSuffix: showNickNameError
                ? joinCtl.nickName.isNotEmpty
                    ? _errorClearBtn(() {
                        setState(() {
                          joinCtl.joinNicknameTFController.clear();
                          joinCtl.nickName = '';
                          showNickNameError = false;
                          joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
                        });
                      })
                    : null
                : joinCtl.nickName.isNotEmpty
                    ? _clearBtn(() {
                        setState(() {
                          joinCtl.joinNicknameTFController.clear();
                          joinCtl.nickName = '';
                          showNickNameError = false;
                          //
                          joinCtl.BtnEnabledArr[joinCtl.pageIndex] = false;
                        });
                      })
                    : null,
          )
        ],
      ),
    );
  }

  bool showNickNameError = false;

  void _nickNameCheckFunction() async {
    if (joinCtl.nickName.isEmpty) {
      WDCommon().toast(context, '닉네임을 입력해주세요.', isError: true);
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    if (!joinCtl.isLoading) {
      setState(() {
        joinCtl.isLoading = true;
      });
    }
    joinCtl.requestCheckNickname(joinCtl.nickName).then((value) {
      if (value.message == 'ok') {
        WDCommon().toast(context, value.data!.result_msg ?? '');
        setState(() {
          showNickNameError = false;
          joinCtl.nickNameCheck = true;
          joinCtl.BtnEnabledArr[joinCtl.pageIndex] =
              value.data!.error_code == 1 ? false : true;
          joinCtl.isLoading = false;
        });
        _function();
        if(KeyboardUtil.keyboardOpen()){
          KeyboardUtil.closeKeyBoard();
        }
      } else {
        // WDCommon().toast(context, value.message, isError: true);
        setState(() {
          showNickNameError = true;
          joinCtl.nickNameCheck = false;
        });
      }

      setState(() {
        joinCtl.isLoading = false;
      });
    });
  }

  final TextInputFormatter _onlyKrEngNumber = FilteringTextInputFormatter(
      RegExp(
          r'[a-z|A-Z|0-9|ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|ㆍ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]'),
      allow: true);
  final TextInputFormatter _onlyKrEng = FilteringTextInputFormatter(
      RegExp(
          r'[a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|ㆍ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]'),
      allow: true);

  Widget _clearBtn(Function() function) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: function,
        child: SizedBox(
          width: 18,
          height: 18,
          child: Image.asset('assets/images/ic_clear.png'),
        ),
      ),
    );
  }

  Widget _errorClearBtn(Function() function) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: function,
        child: SizedBox(
          width: 18,
          height: 18,
          child: Image.asset('assets/images/ic_clear_error.png'),
        ),
      ),
    );
  }
}
