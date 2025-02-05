import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/component/wd_appbar.dart';
import 'package:weedool/component/wd_tab2_bar.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/controllers/activity/activity_controller.dart';
import 'package:weedool/models/activity/model_activity_add.dart';
import 'package:weedool/models/model_base.dart';
import 'package:weedool/utils/ga_util.dart';
import 'package:weedool/utils/logger.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/views/activity/activity_add_item.dart';
import 'package:weedool/views/home.dart';
import 'package:weedool/views/loading_page.dart';

class ActivityAdd extends StatefulWidget {
  final int idx;
  final List<AddActivity> dailyList;
  final List<AddActivity> weeklyList;
  final bool isDailyFull;
  final bool isWeeklyFull;

  ActivityAdd(
      {super.key,
      required this.idx,
      required this.dailyList,
      required this.weeklyList,
      this.isDailyFull = false,
      this.isWeeklyFull = false});

  @override
  State<StatefulWidget> createState() => _ActivityAdd();
}

class _ActivityAdd extends State<ActivityAdd> {
  late final Size size = MediaQuery.of(context).size;

  final ValueNotifier<bool> _loading = ValueNotifier(false);
  bool _isDailyFull = false;
  bool _isWeeklyFull = false;

  @override
  void initState() {
    GaUtil().trackScreen('ActivityAddPage', input: {'uuid': WDCommon().uuid});
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.dailyList.isEmpty) {
        setState(() {
          _isDailyEmpty = true;
        });
      }
      if (widget.weeklyList.isEmpty) {
        setState(() {
          _isWeeklyEmpty = true;
        });
      }
    });
  }

  //
  @override
  void dispose() {
    super.dispose();
  }

  final List<String> _tabList = ['일일 미션', '주간 미션'];
  late int _selectedIdx = widget.idx;
  bool _isDailyEmpty = false;
  bool _isWeeklyEmpty = false;
  String _selectedActivityId = '';
  bool _isSelectedItemIsDaily = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (_) {
          _backProcess();
        },
        canPop: false,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WDAppbar(
                      buildContext: context,
                      function: () {
                        _backProcess();
                      },
                    ),
                    WDTab2Bar(
                      textList: _tabList,
                      function: (idx) {
                        if (_selectedIdx == 0) {
                          if (widget.isWeeklyFull) {
                            WDCommon().toast(context, '주간 미션 7개를 모두 추가하셨어요!',
                                isError: true);
                            return;
                          } else {
                            setState(() {
                              _selectedIdx = idx;
                            });
                          }
                        } else {
                          if (widget.isDailyFull) {
                            WDCommon().toast(context, '일일 미션 7개를 모두 추가하셨어요!',
                                isError: true);
                            return;
                          } else {
                            setState(() {
                              _selectedIdx = idx;
                            });
                          }
                        }
                      },
                      selectedIdx: _selectedIdx,
                    ),
                    SizedBox(
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 22, top: 20, bottom: 16),
                        child: Text(
                          '어떤 ${_selectedIdx == 0 ? '일일' : '주간'} 미션을 추가해볼까요?',
                          style: Styler.style(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                        child: _content(_selectedIdx == 0
                            ? widget.dailyList
                            : widget.weeklyList))
                  ],
                ),
                Positioned(bottom: 0, child: _addBtn()),
                ValueListenableBuilder(
                    valueListenable: _loading,
                    builder: (_, value, child) {
                      return LoadingPage(isLoading: value);
                    })
              ],
            ),
          ),
        ));
  }

  final ValueNotifier<bool> _backInvoked = ValueNotifier(false);

  void _backProcess() {
    if (!_backInvoked.value) {
      _backInvoked.value = true;
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  final String _imgUrl =
      'https://weedool-app-mvp.s3.ap-northeast-2.amazonaws.com/icon/ba/';

  Widget _content(List<AddActivity> input) {
    if (_isDailyEmpty || _isWeeklyEmpty) {
      return _empty();
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
            input.length,
            (idx) => Padding(
                  padding: EdgeInsets.only(
                      bottom: idx == input.length - 1 ? 120 : 12,
                      top: idx == 0 ? 12 : 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedIdx == 0) {
                          _isSelectedItemIsDaily = true;
                        } else {
                          _isSelectedItemIsDaily = false;
                        }
                        _selectedActivityId = input[idx].activitiy_id;
                      });
                    },
                    child: ActivityAddItem(
                      title: input[idx].activity_name,
                      time: input[idx].time_tag,
                      activity: input[idx].category,
                      desc: input[idx].description,
                      imgPath: '$_imgUrl${input[idx].activitiy_id}.png',
                      isSelected:
                          _selectedActivityId == input[idx].activitiy_id,
                    ),
                  ),
                )),
      ),
    );
  }

  Widget _empty() {
    return Expanded(
        child: SizedBox(
      width: size.width,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.top + 56 + 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '더 이상 추가할 수 있는\n활동이 없어요',
              style: Styler.style(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              '내일 다시 해보세요!',
              style: Styler.style(
                  color: WDColors.grey500,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.5),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    ));
  }

  bool _showBtn(int nowIdx, bool loading) {
    if (loading) {
      return false;
    } else {
      if (nowIdx == 0) {
        if (_isDailyEmpty) {
          return false;
        }
      } else {
        if (_isWeeklyEmpty) {
          return false;
        }
      }
      return true;
    }
  }

  final ActivityController activityController = ActivityController();

  Widget _addBtn() {
    return ValueListenableBuilder(
        valueListenable: _loading,
        builder: (_, value, child) {
          return Visibility(
              visible: _showBtn(_selectedIdx, value),
              child: GestureDetector(
                onTap: () async {
                  if (_isRightSelected()) {
                    setState(() {
                      _loading.value = true;
                    });
                    BaseModel data = await activityController
                        .requestAddActivity(_selectedActivityId);
                    WDLog.e('data : ${data.message}');
                    if (data.message == 'ok') {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const HomeView(
                                    selectedIndex: 4,
                                  )),
                          (route) => false);
                    } else {
                      setState(() {
                        _loading.value = false;
                      });
                      WDCommon().toast(context, data.message, isError: true);
                    }
                  } else {
                    setState(() {
                      _loading.value = false;
                    });
                    WDCommon().toast(context, '활동을 선택해주세요.', isError: true);
                  }
                },
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 0),
                        spreadRadius: 4,
                        blurRadius: 0.5)
                  ]),
                  child: Container(
                    width: size.width - 48,
                    height: 52,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: _isRightSelected()
                            ? WDColors.primaryColor
                            : WDColors.assitive),
                    child: Center(
                      child: Text(
                        '추가하기',
                        style: Styler.style(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ));
        });
  }

  bool _isRightSelected() {
    if (_isSelectedItemIsDaily) {
      if (_selectedIdx == 0) {
        if (_selectedActivityId != '') {
          return true;
        }
      }
    } else {
      if (_selectedIdx == 1) {
        if (_selectedActivityId != '') {
          return true;
        }
      }
    }
    return false;
  }
}
