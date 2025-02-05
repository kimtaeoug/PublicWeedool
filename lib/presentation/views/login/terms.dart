import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_text_style.dart';
import 'package:weedool/controllers/login/controller_join.dart';
import 'package:weedool/views/login/join.dart';

import 'package:weedool/views/login/terms_detail.dart';

class TermsView extends StatefulWidget {
  const TermsView({Key? key}) : super(key: key);

  @override
  State<TermsView> createState() => _TermsState();
}

class _TermsState extends State<TermsView> {
  double height = 0;
  double width = 0;

  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  bool _isChecked5 = false;

  bool _buttonEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      JoinCtl().clearData();
    });
  }

  void checkChange() {
    if (_isChecked2 && _isChecked3 && _isChecked4 && _isChecked5) {
      _isChecked1 = true;
      _buttonEnabled = true;
    } else {
      _isChecked1 = false;
      if (_isChecked2 && _isChecked3 && _isChecked4) {
        _buttonEnabled = true;
      } else {
        _buttonEnabled = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: Scaffold(
            backgroundColor: WDColors.backgroundColor,
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: width,
                height: height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top + 10,
                                bottom: 75),
                            child: _backBtn(),
                          ),
                          _characterArea(),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _text1Area(),
                          const SizedBox(
                            height: 6,
                          ),
                          _text2Area(),
                          _checkbox1Area(),
                          _lineArea(),
                          _checkbox2Area(),
                          _checkbox3Area(),
                          _checkbox4Area(),
                          _checkbox5Area(),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 70),
                            child: InkWell(
                                onTap: () => {
                                      if (_buttonEnabled)
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const JoinView()),
                                          )
                                        }
                                    },
                                child: Container(
                                    height: 52,
                                    width: width,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        color: _buttonEnabled
                                            ? WDColors.primaryColor
                                            : WDColors.assitive),
                                    child: Center(
                                        child: Text(
                                      '다음',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.heading3(
                                          WDColors.white),
                                    )))),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget _backBtn() {
    return SizedBox(
      width: width,
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: SizedBox(
            width: 24,
            height: 24,
            child: Image.asset(
              'assets/images/ic_btn_back.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _characterArea() {
    return Image.asset('assets/images/character_login.png',
        width: 120, height: 120, fit: BoxFit.contain);
  }

  Widget _text1Area() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text('회원가입하기',
          textAlign: TextAlign.center,
          style: AppTextStyles.body2(const Color(0xFF818181))),
    );
  }

  Widget _text2Area() {
    return Text('위둘,시작해볼까요?',
        textAlign: TextAlign.center,
        style: AppTextStyles.heading1(WDColors.black));
  }

  Widget _checkbox1Area() {
    return Container(
        margin: const EdgeInsets.only(top: 63),
        child: Row(
          children: [
            Checkbox(
              value: _isChecked1,
              onChanged: (value) => {
                setState(() {
                  _isChecked1 = value!;
                  _isChecked2 = value;
                  _isChecked3 = value;
                  _isChecked4 = value;
                  _isChecked5 = value;
                  _buttonEnabled = value;
                })
              },
              activeColor: WDColors.black,
              checkColor: WDColors.white,
            ),
            Text('전체 동의하기',
                textAlign: TextAlign.center,
                style: AppTextStyles.body4(WDColors.black)),
          ],
        ));
  }

  Widget _lineArea() {
    return Container(
      width: width,
      height: 1,
      decoration: const BoxDecoration(color: Color(0xFFC6C6C6)),
      margin: const EdgeInsets.only(left: 13, right: 13),
    );
  }

  Widget _checkbox2Area() {
    return Container(
        child: Row(
      children: [
        Checkbox(
          value: _isChecked2,
          onChanged: (value) => {
            setState(() {
              _isChecked2 = value!;
              checkChange();
            })
          },
          activeColor: WDColors.black,
          checkColor: WDColors.white,
        ),
        GestureDetector(
          onTap: () async {
            final data = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TermsDetailView(
                          termStatus: 0,
                        )));
            if (data) {
              setState(() {
                _isChecked2 = true;
                checkChange();
              });
            }
          },
          child: Row(
            children: [
              Text('(필수)',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body4(const Color(0xFFDE0E0E))),
              Text(' 위둘 서비스 이용 약관',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body4(Colors.black)),
            ],
          ),
        )
      ],
    ));
  }

  Widget _checkbox3Area() {
    return Container(
        child: Row(
      children: [
        Checkbox(
          value: _isChecked3,
          onChanged: (value) => {
            setState(() {
              _isChecked3 = value!;
              checkChange();
            })
          },
          activeColor: WDColors.black,
          checkColor: WDColors.white,
        ),
        GestureDetector(
          onTap: () async {
            final data = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TermsDetailView(
                          termStatus: 1,
                        )));
            if (data) {
              setState(() {
                _isChecked3 = true;
                checkChange();
              });
            }
          },
          child: Row(
            children: [
              Text('(필수)',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body4(const Color(0xFFDE0E0E))),
              Text(' 개인정보 수집 및 이용 동의서',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body4(Colors.black)),
            ],
          ),
        )
      ],
    ));
  }

  Widget _checkbox4Area() {
    return Container(
        child: Row(
      children: [
        Checkbox(
          value: _isChecked4,
          onChanged: (value) => {
            setState(() {
              _isChecked4 = value!;
              checkChange();
            })
          },
          activeColor: WDColors.black,
          checkColor: WDColors.white,
        ),
        GestureDetector(
          onTap: () async {
            final data = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TermsDetailView(
                          termStatus: 2,
                        )));
            if (data) {
              setState(() {
                _isChecked4 = true;
                checkChange();
              });
            }
          },
          child: Row(
            children: [
              Text('(필수)',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body4(const Color(0xFFDE0E0E))),
              Text(' 개인정보 처리 방침',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body4(Colors.black)),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _checkbox5Area() {
    return Container(
        child: Row(
      children: [
        Checkbox(
          value: _isChecked5,
          onChanged: (value) => {
            setState(() {
              _isChecked5 = value!;
              checkChange();
            })
          },
          activeColor: WDColors.black,
          checkColor: WDColors.white,
        ),
        GestureDetector(
          onTap: () async {
            final data = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TermsDetailView(
                          termStatus: 3,
                        )));
            if (data) {
              setState(() {
                _isChecked5 = true;
                checkChange();
              });
            }
          },
          child: Row(
            children: [
              Text('(선택)',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body4(const Color(0xFF6A6A6A))),
              Text(' 마케팅 정보 수신 동의',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body4(Colors.black)),
            ],
          ),
        ),
      ],
    ));
  }
}
