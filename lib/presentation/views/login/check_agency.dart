import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weedool/component/wd_btn.dart';
import 'package:weedool/component/wd_text_input.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/component/dialog.dart';
import 'package:weedool/controllers/login/controller_check_agency.dart';
import 'package:weedool/utils/keyboard_util.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/views/loading_page.dart';

import 'package:weedool/views/login/login.dart';

class CheckAgencyView extends StatefulWidget {
  const CheckAgencyView({super.key});

  @override
  State<CheckAgencyView> createState() => _CheckAgencyState();
}

class _CheckAgencyState extends State<CheckAgencyView> {
  double height = 0;
  double width = 0;

  CheckAgencyCtl checkAgencyCtl = CheckAgencyCtl();

  bool _checkCodeEmpty = true;

  void _listener() {
    if (checkAgencyCtl.codeTFController.text.isEmpty) {
      setState(() {
        _checkCodeEmpty = true;
      });
    } else {
      setState(() {
        _checkCodeEmpty = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkAgencyCtl.codeTFController.addListener(_listener);
  }

  @override
  void dispose() {
    checkAgencyCtl.codeTFController.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;
    return PopScope(
        canPop: false,
        onPopInvoked: (_) {
          WDDialog.twoBtnDialog(context, '앱을 종료하시겠습니까?', '아니요', '네',
              (dialogContext) {
            Navigator.pop(dialogContext);
          }, (dialogContext) {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else {
              exit(0);
            }
          });
        },
        child: MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: Scaffold(
              backgroundColor: WDColors.backgroundColor,
              body: SizedBox(
                width: width,
                height: height,
                child: Stack(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 76,
                            left: 20),
                        child: Text(
                          '기관 코드를 입력해주세요',
                          style: Styler.style(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                      _body(),
                    ],
                  ),
                  Positioned(
                      bottom: KeyboardUtil.keyboardOpen() ? 24 : 40,
                      child: WDBtn(
                        text: '다음',
                        width: width - 40,
                        height: 52,
                        function: () {
                          _process();
                        },
                        color: _checkCodeEmpty
                            ? WDColors.assitive
                            : WDColors.primaryColor,
                      )),
                  LoadingPage(isLoading: checkAgencyCtl.isLoading)
                ]),
              )),
        ));
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      child: WDTextInput(
        label: '기관 코드',
        width: width,
        controller: checkAgencyCtl.codeTFController,
        onChanged: (value) {
          if (value != null) {
            if (_showError) {
              setState(() {
                _showError = false;
              });
            }
            checkAgencyCtl.txtAgency = value;
          }
        },
        hintText: '기관코드를 입력해주세요',
        onSubmitted: (value) {
          _process();
        },
        isError: _showError,
        clearSuffix: _showError
            ? _errorClearBtn(() {
                setState(() {
                  checkAgencyCtl.txtAgency = '';
                  checkAgencyCtl.codeTFController.clear();
                  _showError = false;
                  _checkCodeEmpty = true;
                });
              })
            : !_checkCodeEmpty
                ? _clearBtn(() {
                    setState(() {
                      checkAgencyCtl.txtAgency = '';
                      checkAgencyCtl.codeTFController.clear();
                      _showError = false;
                      _checkCodeEmpty = true;
                    });
                  })
                : null,
      ),
    );
  }

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

  bool _showError = false;

  void _process() {
    if (_checkCodeEmpty) {
      WDCommon().toast(context, '기관코드를 입력해주세요.', isError: true);
      return;
    }
    if (!checkAgencyCtl.isLoading) {
      setState(() {
        checkAgencyCtl.isLoading = true;
      });
    }
    checkAgencyCtl.requestCheckAgency().then((value) {
      if (value.message == 'ok') {
        if (value.data!.error_code == 1) {
          setState(() {
            _showError = true;
            _checkCodeEmpty = true;
          });
          WDCommon()
              .toast(context, value.data!.result_msg ?? '', isError: true);
        } else {
          WDCommon().agency_code = checkAgencyCtl.txtAgency;
          if (KeyboardUtil.keyboardOpen()) {
            KeyboardUtil.closeKeyBoard();
          }
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
              (route) => false);
        }
      } else {
        setState(() {
          _showError = true;
          _checkCodeEmpty = true;
        });
        WDCommon().toast(context, value.message, isError: true);
      }
      setState(() {
        checkAgencyCtl.isLoading = false;
      });
    });
  }
}
