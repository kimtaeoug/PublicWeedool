import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weedool/component/dialog.dart';
import 'package:weedool/component/wd_answer_container.dart';
import 'package:weedool/component/wd_btn.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_text_style.dart';
import 'package:weedool/controllers/login/controller_member_info.dart';
import 'package:weedool/models/login/data_join.dart';
import 'package:weedool/utils/page_observer.dart';
import 'package:weedool/utils/preference_util.dart';
import 'package:weedool/utils/ui_util.dart';
import 'package:weedool/views/loading_page.dart';
import 'package:weedool/views/login/join_result.dart';

//todo
//회원가입시 intake에서
// 변경 버튼 누른 후 페이지 이동은 다시 변경 버튼이 있는 페이지로 가는걸로

class MemberInfoView extends StatefulWidget {
  final JoinData joinData;
  final bool joinProcess;

  const MemberInfoView(
      {super.key, required this.joinData, this.joinProcess = false});

  @override
  State<MemberInfoView> createState() => _MemberInfoState();
}

class _MemberInfoState extends State<MemberInfoView> {
  double height = 0;
  double width = 0;

  MemberInfoCtl memberInfoCtl = MemberInfoCtl();
  final PageObserver observer = PageObserver();

  final GlobalKey _key = GlobalKey();
  double _headerHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Size? size = UiUtil.widgetSize(_key);
      if (size != null) {
        setState(() {
          _headerHeight = size.height;
        });
      }
    });
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
        child: _body());
  }

  Widget _body() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: WDColors.backgroundColor,
        body: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: Stack(children: [
              SizedBox(
                width: width,
                height: height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _headerContents(),
                      SizedBox(
                        height: height - _headerHeight,
                        child: _bodyContents(),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _footerContents(),
              ),
              LoadingPage(isLoading: memberInfoCtl.isLoading)
            ])));
  }

  bool _checkBack = false;

  Future<void> _backProcess() async {
    if (widget.joinProcess) {
      if (memberInfoCtl.pageIndex == 0) {
        if (_checkBack) {
          return;
        }
        Future.delayed(Duration.zero).whenComplete(() {
          _checkBack = true;
          Navigator.pop(context);
          return;
        });
      }
    }
    if (memberInfoCtl.pageIndex != 0) {
      setState(() {
        memberInfoCtl.pageIndex -= 1;
      });
      _pageController.animateToPage(memberInfoCtl.pageIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  Widget _headerContents() {
    return Container(
      key: _key,
      margin: const EdgeInsets.only(top: 66),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 34,
      width: width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () async {
            await _backProcess();
          },
          child: SizedBox(
            width: 24,
            height: 24,
            child: Image.asset('assets/images/ic_btn_back.png'),
          ),
        ),
      ),
    );
  }

  final PageController _pageController = PageController(initialPage: 0);

  Widget _bodyContents() {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      pageSnapping: false,
      itemBuilder: (_, idx) {
        switch (idx) {
          // switch (memberInfoCtl.pageIndex) {
          case 0:
            return _infoAgeView(idx);
          case 1:
            return _infoSexView(idx);
          case 2:
            return _infoQuestion1View(idx);
          case 3:
            return _infoQuestion2View(idx);
          case 4:
            return _infoSleepView(idx);
          case 5:
            return _infoSleepTimeView(idx);
          case 6:
            return _infoResultView(idx);
          default:
            return Container();
        }
      },
      onPageChanged: (idx) {
        setState(() {
          memberInfoCtl.pageIndex = idx;
        });
      },
    );
  }

  bool isClicked = false;
  final PreferenceUtil preferenceUtil = PreferenceUtil();

  Widget _footerContents() {
    if (memberInfoCtl.pageIndex == 6) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: WDBtn(
            text: '다음',
            width: width,
            height: 52,
            function: () {
              if (!isClicked) {
                preferenceUtil.setCheckSleep(false);
                preferenceUtil.setCheckMood(false);
                isClicked = true;
                setState(() {
                  memberInfoCtl.isLoading = true;
                });
                memberInfoCtl.requestJoin(widget.joinData).then((value) async {
                  if (value.message == 'ok') {
                    WDCommon().toast(context, '회원가입에 성공했습니다.');
                    if (value.data!.error_code == 0) {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString('uuid', value.data!.uuid!);
                      WDCommon().uuid = value.data!.uuid!;
                      setState(() {
                        memberInfoCtl.isLoading = false;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JoinResultView(
                                    nick_name: widget.joinData.nick_name,
                                  )));
                    } else {
                      setState(() {
                        memberInfoCtl.isLoading = false;
                      });
                      WDCommon().toast(context, value.message, isError: true);
                    }
                  } else {
                    isClicked = false;
                    setState(() {
                      memberInfoCtl.isLoading = false;
                    });
                    WDCommon().toast(context, value.message, isError: true);
                  }
                });
              }
            }),
      );
    } else {
      return Container();
    }
  }

  // age , sex ,cigarette , drink , sleep , sleeptime
  String _beforeAge = '';

  Widget _addSelectBox(String txt, int idx) {
    return WDAnswerContainer(
      text: txt,
      function: () {
        setState(() {
          switch (memberInfoCtl.pageIndex) {
            case 0:
              if (_isModify) {
                _beforeAge = memberInfoCtl.age;
              }
              memberInfoCtl.age = txt;
              break;
            case 2:
              if (memberInfoCtl.age == '10대') {
                memberInfoCtl.breakfast = txt;
              } else if (memberInfoCtl.age == '65세 이상') {
                memberInfoCtl.exercise = txt;
              } else {
                memberInfoCtl.cigarette = txt;
              }
              break;
            case 3:
              if (memberInfoCtl.age == '10대') {
                memberInfoCtl.instant = txt;
              } else if (memberInfoCtl.age == '65세 이상') {
                memberInfoCtl.meet_person = txt;
              } else {
                memberInfoCtl.drink = txt;
              }
              break;
            case 4:
              memberInfoCtl.sleep1 = txt;
              break;
            case 5:
              memberInfoCtl.sleep2 = txt;
              break;
          }
          if (_isModify) {
            if (memberInfoCtl.pageIndex == 0) {
              if (_beforeAge == '10대') {
                if (memberInfoCtl.age != '10대') {
                  _showDialogChangeAge();
                }
              } else if (_beforeAge == '65세 이상') {
                if (memberInfoCtl.age != '65세 이상') {
                  _showDialogChangeAge();
                }
              } else {
                if (memberInfoCtl.age == '10대' ||
                    memberInfoCtl.age == '65세 이상') {
                  _showDialogChangeAge();
                } else {
                  setState(() {
                    memberInfoCtl.pageIndex = 6;
                  });
                  _move(memberInfoCtl.pageIndex);
                  _isModify = false;
                }
              }
            } else {
              setState(() {
                memberInfoCtl.pageIndex = 6;
              });
              _move(memberInfoCtl.pageIndex);
              _isModify = false;
            }
          } else {
            if (_ageUpdate && memberInfoCtl.pageIndex == 3) {
              setState(() {
                memberInfoCtl.pageIndex = 6;
              });
              _move(memberInfoCtl.pageIndex, isAnimated: true);
              _ageUpdate = false;
            } else {
              _move(memberInfoCtl.pageIndex + 1, isAnimated: false);
            }
          }
        });
      },
      width: width - 66,
      height: 64,
      isSelected: _checkSelected(txt, idx),
    );
  }

  bool _checkSelected(String txt, int idx) {
    switch (idx) {
      // switch (memberInfoCtl.pageIndex) {
      case 0:
        return memberInfoCtl.age == txt;
      case 2:
        if (memberInfoCtl.age == '10대') {
          return memberInfoCtl.breakfast == txt;
        } else if (memberInfoCtl.age == '65세 이상') {
          return memberInfoCtl.exercise == txt;
        } else {
          return memberInfoCtl.cigarette == txt;
        }
      case 3:
        if (memberInfoCtl.age == '10대') {
          return memberInfoCtl.instant == txt;
        } else if (memberInfoCtl.age == '65세 이상') {
          return memberInfoCtl.meet_person == txt;
        } else {
          return memberInfoCtl.drink == txt;
        }
      case 4:
        return memberInfoCtl.sleep1 == txt;
      case 5:
        return memberInfoCtl.sleep2 == txt;
      default:
        return false;
    }
  }

  Widget _addResultBox(int index) {
    String txt1 = '';
    String txt2 = '';

    switch (index) {
      case 0:
        txt1 = '나이';
        txt2 = memberInfoCtl.age;
        break;
      case 1:
        txt1 = '성별';
        txt2 = memberInfoCtl.sex;
        break;
      case 2:
        if (memberInfoCtl.age == '10대') {
          txt1 = '아침식사';
          txt2 = memberInfoCtl.breakfast;
        } else if (memberInfoCtl.age == '65세 이상') {
          txt1 = '운동';
          txt2 = memberInfoCtl.exercise;
        } else {
          txt1 = '흡연 여부';
          txt2 = memberInfoCtl.cigarette;
        }
        break;
      case 3:
        if (memberInfoCtl.age == '10대') {
          txt1 = '인스턴트식품';
          txt2 = memberInfoCtl.instant;
        } else if (memberInfoCtl.age == '65세 이상') {
          txt1 = '사람 만나기';
          txt2 = memberInfoCtl.meet_person;
        } else {
          txt1 = '음주 여부';
          txt2 = memberInfoCtl.drink;
        }
        break;
      case 4:
        txt1 = '취침 시간';
        txt2 = memberInfoCtl.sleep1;
        break;
      case 5:
        txt1 = '취침 길이';
        txt2 = memberInfoCtl.sleep2;
        break;
    }
    return GestureDetector(
        onTap: () {
          _isModify = true;
          _move(index);
          // setState(() {
          //   memberInfoCtl.pageIndex = index;
          // });
        },
        child: Container(
          margin: const EdgeInsets.only(top: 18),
          width: width - 66,
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                width: 1,
                color: const Color(0xFFE7E7E7),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 0.1)
              ]),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Text(txt1,
                  textAlign: TextAlign.left,
                  style: AppTextStyles.body4(const Color(0xff2C7CC3))
                      .copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(
                width: 8,
              ),
              Text(txt2,
                  textAlign: TextAlign.left,
                  style: AppTextStyles.body4(WDColors.black)),
            ]),
            Text(
              '변경',
              textAlign: TextAlign.left,
              style: AppTextStyles.body6(WDColors.gray)
                  .copyWith(decoration: TextDecoration.underline),
            )
          ]),
        ));
  }

  Widget _infoAgeView(int idx) {
    return Container(
      padding: const EdgeInsets.all(33),
      child: Column(children: [
        Container(
          width: width,
          margin: const EdgeInsets.only(top: 3),
          child: Text('나이대가 궁금해요!',
              textAlign: TextAlign.left,
              style: AppTextStyles.heading1(WDColors.black)),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: width,
          height: height - 100 - 185,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  _addSelectBox('10대', idx),
                  _addSelectBox('20대', idx),
                  _addSelectBox('30대', idx),
                  _addSelectBox('40대', idx),
                  _addSelectBox('50대', idx),
                  _addSelectBox('50~64세', idx),
                  _addSelectBox('65세 이상', idx),
                ],
              )),
        )
      ]),
    );
  }

  bool _isModify = false;

  void _move(int page, {bool isAnimated = false}) {
    if (_isModify) {
      _pageController.jumpToPage(page);
    } else {
      if (_ageUpdate && isAnimated) {
        _pageController.jumpToPage(page);
      } else {
        _pageController.animateToPage(page,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);
      }
    }
  }

  bool _checkSex(String text) => memberInfoCtl.sex == text;

  Widget _infoSexView(int idx) {
    return Container(
      padding: const EdgeInsets.all(33),
      child: Column(
        children: [
          Container(
            width: width,
            margin: const EdgeInsets.only(top: 5),
            child: Text('성별은 어떻게 되시나요?',
                textAlign: TextAlign.left,
                style: AppTextStyles.heading1(WDColors.black)),
          ),
          Container(
            width: width,
            margin: const EdgeInsets.only(top: 28),
            child: Text('성별에 따라 필요한 상담이 다를 수 있어요.',
                textAlign: TextAlign.left,
                style: AppTextStyles.body2(WDColors.gray)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 141),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      memberInfoCtl.sex = '남성';
                      // memberInfoCtl.pageIndex += 1;
                    });
                    if (_isModify) {
                      setState(() {
                        memberInfoCtl.pageIndex = 6;
                      });
                      _move(memberInfoCtl.pageIndex);
                      _isModify = false;
                    } else {
                      _move(memberInfoCtl.pageIndex + 1);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 18, right: 19),
                    width: (width - 85) / 2,
                    height: 204,
                    decoration: BoxDecoration(
                        color: _checkSex('남성')
                            ? const Color(0xff3E9CE2).withOpacity(0.1)
                            : Colors.white,
                        border: Border.all(
                          width: 1,
                          color: _checkSex('남성')
                              ? const Color(0xff3E9CE2)
                              : const Color(0xFFE7E7E7),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/ic_login_m.png',
                            width: 89, height: 89, fit: BoxFit.contain),
                        Container(
                          margin: const EdgeInsets.only(top: 31),
                          child: Text('남성',
                              textAlign: TextAlign.left,
                              style: AppTextStyles.heading3(WDColors.black)),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      memberInfoCtl.sex = '여성';
                      // memberInfoCtl.pageIndex += 1;
                    });
                    if (_isModify) {
                      setState(() {
                        memberInfoCtl.pageIndex = 6;
                      });
                      _move(memberInfoCtl.pageIndex);
                      _isModify = false;
                    } else {
                      _move(memberInfoCtl.pageIndex + 1);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 18),
                    width: (width - 85) / 2,
                    height: 204,
                    decoration: BoxDecoration(
                        color: _checkSex('여성')
                            ? const Color(0xff3E9CE2).withOpacity(0.1)
                            : Colors.white,
                        border: Border.all(
                          width: 1,
                          color: _checkSex('여성')
                              ? const Color(0xff3E9CE2)
                              : const Color(0xFFE7E7E7),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/ic_login_f.png',
                            width: 89, height: 89, fit: BoxFit.contain),
                        Container(
                          margin: const EdgeInsets.only(top: 31),
                          child: Text('여성',
                              textAlign: TextAlign.left,
                              style: AppTextStyles.heading3(WDColors.black)),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoQuestion1View(int idx) {
    String strTitle = '';
    String str1 = '';
    String str2 = '';
    String str3 = '';
    String str4 = '';

    print('aa $memberInfoCtl.age');

    if (memberInfoCtl.age == '10대') {
      strTitle = '1주일에 아침을 먹는 날은?';
      str1 = '매일';
      str2 = '3번 이상';
      str3 = '1-2번';
      str4 = '거의 먹지 않는다';
    } else if (memberInfoCtl.age == '65세 이상') {
      strTitle = '1주일에 운동은';
      str1 = '매일';
      str2 = '3번 이상';
      str3 = '1-2번';
      str4 = '거의 하지 않는다';
    } else {
      strTitle = '흡연 여부에 대해 알려주세요';
      str1 = '매일 해요';
      str2 = '3번이상 해요';
      str3 = '기분 안좋을 때만 해요';
      str4 = '잘 모르겠다';
    }

    return Container(
      padding: const EdgeInsets.all(33),
      child: Column(
        children: [
          Container(
            width: width,
            margin: const EdgeInsets.only(top: 5),
            child: Text(strTitle,
                textAlign: TextAlign.left,
                style: AppTextStyles.heading1(WDColors.black)),
          ),
          SizedBox(
            width: width,
            height: height / 10 * 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 22,
                ),
                _addSelectBox(str1, idx),
                _addSelectBox(str2, idx),
                _addSelectBox(str3, idx),
                _addSelectBox(str4, idx),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoQuestion2View(int idx) {
    String strTitle = '';
    String str1 = '';
    String str2 = '';
    String str3 = '';
    String str4 = '';

    if (memberInfoCtl.age == '10대') {
      strTitle = '1주일에 인스턴트(라면, 햄버거, 피자, 콜라 등) 식품을 먹는 날은?';
      str1 = '매일';
      str2 = '3번 이상';
      str3 = '1-2번';
      str4 = '거의 먹지 않는다';
    } else if (memberInfoCtl.age == '65세 이상') {
      strTitle = '1주일에 만나는 사람은';
      str1 = '매일 1명 이상';
      str2 = '3명 이상';
      str3 = '1-2명';
      str4 = '만나는 사람 없다';
    } else {
      strTitle = '음주 여부가 궁금해요';
      str1 = '아예 안해요';
      str2 = '기분 좋을 때만 해요';
      str3 = '기분 안좋을 때만 해요';
      str4 = '잘 모르겠다';
    }
    return Container(
      padding: const EdgeInsets.all(33),
      child: Column(
        children: [
          Container(
            width: width,
            margin: const EdgeInsets.only(top: 5),
            child: Text(strTitle,
                textAlign: TextAlign.left,
                style: AppTextStyles.heading1(WDColors.black)),
          ),
          SizedBox(
            width: width,
            height: height / 10 * 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 22,
                ),
                _addSelectBox(str1, idx),
                _addSelectBox(str2, idx),
                _addSelectBox(str3, idx),
                _addSelectBox(str4, idx),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoSleepView(int idx) {
    return Container(
      padding: const EdgeInsets.all(33),
      child: Column(
        children: [
          Container(
            width: width,
            margin: const EdgeInsets.only(top: 5),
            child: Text('잠은 언제 주무시나요?',
                textAlign: TextAlign.left,
                style: AppTextStyles.heading1(WDColors.black)),
          ),
          Container(
            width: width,
            margin: const EdgeInsets.only(top: 10),
            child: Text('평소 주무시는 시간을 선택해주세요.',
                textAlign: TextAlign.left,
                style: AppTextStyles.body2(const Color(0xff858588))),
          ),
          SizedBox(
            width: width,
            height: height - 257,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 22,
                ),
                _addSelectBox('밤 9시~12시', idx),
                _addSelectBox('밤 12시 ~ 새벽 2시', idx),
                _addSelectBox('새벽 2시 ~ 새벽 4시', idx),
                _addSelectBox('그 외 시간', idx),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoSleepTimeView(int idx) {
    return Container(
      padding: const EdgeInsets.all(33),
      child: Column(
        children: [
          Container(
            width: width,
            margin: const EdgeInsets.only(top: 5),
            child: Text('잠은 얼마나 주무시나요?',
                textAlign: TextAlign.left,
                style: AppTextStyles.heading1(WDColors.black)),
          ),
          Container(
            width: width,
            margin: const EdgeInsets.only(top: 10),
            child: Text('평소 몇 시간 정도 주무시는지 선택해주세요.',
                textAlign: TextAlign.left,
                style: AppTextStyles.body2(WDColors.gray)),
          ),
          SizedBox(
            width: width,
            height: height - 257,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 22,
                ),
                _addSelectBox('2시간 이하', idx),
                _addSelectBox('3~4 시간', idx),
                _addSelectBox('5~6 시간', idx),
                _addSelectBox('6시간 이상', idx),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoResultView(int idx) {
    return Container(
      padding: const EdgeInsets.all(33),
      child: Column(
        children: [
          Container(
            width: width,
            margin: const EdgeInsets.only(top: 5),
            child: Text('검토해주세요!',
                textAlign: TextAlign.left,
                style: AppTextStyles.heading1(WDColors.black)),
          ),
          SizedBox(
            width: width,
            height: height - 285,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 22,
                  ),
                  _addResultBox(0),
                  _addResultBox(1),
                  _addResultBox(2),
                  _addResultBox(3),
                  _addResultBox(4),
                  _addResultBox(5),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _ageUpdate = false;

  void _showDialogChangeAge() {
    WDDialog.twoBtnDialog(
        context,
        '나이를 변경하시겠습니까?',
        subTitle: '나이를 변경하면 나머지 질문지가 바뀝니다.',
        '아니오',
        '네', (dialogContext) {
      memberInfoCtl.age = _beforeAge;
      _beforeAge = '';
      Navigator.pop(dialogContext);
      if (_isModify) {
        setState(() {
          memberInfoCtl.pageIndex = 6;
        });
        _move(memberInfoCtl.pageIndex);
        _isModify = false;
      }
    }, (dialogContext) {
      Navigator.pop(dialogContext);
      if (memberInfoCtl.age == '10대') {
        memberInfoCtl.breakfast = '';
        memberInfoCtl.instant = '';
      } else if (memberInfoCtl.age == '65세 이상') {
        memberInfoCtl.exercise = '';
        memberInfoCtl.meet_person = '';
      } else {
        memberInfoCtl.cigarette = '';
        memberInfoCtl.drink = '';
      }
      _move(memberInfoCtl.pageIndex + 2);
      _isModify = false;
      _ageUpdate = true;
    });
  }
}

enum MemberInfoType { age, sex, teenager, adult, oldMan, sleep1, sleep2 }
