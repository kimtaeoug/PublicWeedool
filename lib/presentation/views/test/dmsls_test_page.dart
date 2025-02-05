import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/component/wd_answer_container.dart';
import 'package:weedool/component/wd_appbar.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_text_style.dart';
import 'package:weedool/controllers/test/test_controller.dart';
import 'package:weedool/models/model_checkup.dart';
import 'package:weedool/utils/ui_util.dart';
import 'package:weedool/views/checkup_result.dart';
import 'package:weedool/views/loading_page.dart';
import 'package:weedool/views/test/test_indicator.dart';

class DmslsTestPage extends StatefulWidget {
  final String category;
  final CheckupModel? model;

  const DmslsTestPage({super.key, required this.category, this.model});

  @override
  State<StatefulWidget> createState() => _DmslsTestPage();
}

class _DmslsTestPage extends State<DmslsTestPage> {
  late final Size size = MediaQuery.of(context).size;
  double _text4Line = 0;

  final TestController testController = TestController();
  CheckupModel? _checkupModel = null;
  bool _isLoading = true;
  int _qLength = 0;

  //
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      late CheckupModel response;
      if (widget.model != null) {
        response = widget.model!;
      } else {
        response = await testController.requestCheckup(widget.category);
      }
      double height = UiUtil.textSize('이', _textStyle,
              maxWidth: size.width - 66, maxLines: 1)
          .height;
      setState(() {
        _checkupModel = response;
        _qLength = _checkupModel!.data.questions.length;
        _isLoading = false;
        _text4Line = height;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  int pageIdx = 0;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    return PopScope(
        canPop: false,
        onPopInvoked: (_) {
          _backFunction();
        },
        child: MediaQuery(
          data: data.copyWith(textScaler: data.textScaleFactor > 1 ? null : TextScaler.noScaling),
          child: _body(),
        ));
  }

  Widget _body() {
    return Scaffold(
        backgroundColor: WDColors.backgroundColor,
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(children: [
            // CustomScrollView(
            //   slivers: [
            //     SliverToBoxAdapter(
            //           child : WDAppbar(
            //             buildContext: context,
            //             function: () {
            //               _backFunction();
            //             },
            //           ),
            //     ),
            //     SliverFillRemaining(
            //       fillOverscroll: ,
            //       // hasScrollBody: false,
            //       child: Expanded(
            //         child: SizedBox(
            //           width: size.width,
            //           child: _content(),
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            Column(
              children: [
                WDAppbar(
                  buildContext: context,
                  function: () {
                    _backFunction();
                  },
                ),
                _isLoading ? Container() : Expanded(child: _content())
              ],
            ),
            LoadingPage(isLoading: _isLoading)
          ]),
        ));
  }

  final ValueNotifier<bool> _invokeBack = ValueNotifier(false);

  void _backFunction() async {
    if (!_invokeBack.value) {
      _invokeBack.value = true;
      if (pageIdx != 0) {
        setState(() {
          pageIdx--;
        });
        await _pageController.animateToPage(pageIdx,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);
        _invokeBack.value = false;
      } else {
        Navigator.pop(context);
      }
    }
  }

  final PageController _pageController = PageController(initialPage: 0);

  Widget _content() {
    // return CustomScrollView(
    //   slivers: [
    //     SliverToBoxAdapter(
    //       child: Padding(
    //         padding: EdgeInsets.only(top: 20),
    //         child: TestIndicator(value: (pageIdx + 1) / _qLength),
    //       ),
    //     ),
    //     SliverFillRemaining(
    //       child: Container(
    //         width: size.width,
    //         color: Colors.transparent,
    //         child: _bodyContentsPageView(),
    //       ),
    //     )
    //   ],
    // );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: TestIndicator(value: (pageIdx + 1) / _qLength),
        ),
        Expanded(child: _bodyContentsPageView())
      ],
    );
  }
  //
  Widget _bodyContentsPageView() {
    return Container(
      height: size.height,
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        pageSnapping: false,
        onPageChanged: (idx){
          setState(() {
            pageIdx = idx;
          });
        },
        children: List.generate(_qLength, (idx) => _testItem(idx)),
      ),
      // child: PageView.builder(
      //     physics: const NeverScrollableScrollPhysics(),
      //     pageSnapping: false,
      //     controller: _pageController,
      //     onPageChanged: (idx) {
      //       setState(() {
      //         pageIdx = idx;
      //       });
      //     },
      //     itemBuilder: (_, idx) {
      //       return _testItem(idx);
      //     }),
    );
  }

  final TextStyle _textStyle = AppTextStyles.heading1(WDColors.black);

  Widget _testItem(int idx) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              // height: _text4Line * 7,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: size.width,
                  margin: const EdgeInsets.only(top: 64),
                  child: Text(_checkupModel!.data.questions[idx],
                      textAlign: TextAlign.left, style: _textStyle),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              children: List.generate(4, (index) => _item(index)),
            ),
            const SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }

  String _answerText(int idx) {
    switch (idx) {
      case 0:
        return '전혀 그렇지 않다';
      case 1:
        return '그렇지 않다';
      case 2:
        return '그렇다';
      case 3:
        return '매우 그렇다';
      default:
        return '';
    }
  }

  final ValueNotifier<bool> _isClicked = ValueNotifier(false);

  Widget _item(int idx) {
    return GestureDetector(
      onTap: () async {
        await _click(idx);
        if (pageIdx + 1 < _qLength) {
          if (_resultMap.value[pageIdx] != -1 &&
              _resultMap.value[pageIdx] != null) {
            Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
              pageIdx++;
              _pageController.animateToPage(pageIdx,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear);
            });
          }
        } else {
          if (!_resultMap.value.values.contains(-1)) {
            if (!_isClicked.value) {
              _isClicked.value = true;
              setState(() {
                _isLoading = true;
              });
              await testController
                  .requestAddCheckup(
                      widget.category, _resultMap.value.values.toList())
                  .then((data) {
                if (data.data.error_code == 0) {
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckupResultView(
                                checkupAddModel: data,
                                category: widget.category,
                              )));
                } else {
                  setState(() {
                    _isLoading = false;
                  });
                  _isClicked.value = false;
                  WDCommon()
                      .toast(context, data.data.error_msg ?? '', isError: true);
                }
              });
            }
          }
        }
      },
      child: ValueListenableBuilder(
          valueListenable: _resultMap,
          builder: (_, value, child) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: WDAnswerContainer(
                text: _answerText(idx),
                function: null,
                width: size.width,
                height: 64,
                isSelected: value[pageIdx] == idx,
              ),
            );
          }),
    );
  }

  final ValueNotifier<Map<int, int>> _resultMap = ValueNotifier({});

  Future<void> _click(int idx) async {
    if (pageIdx < _qLength) {
      setState(() {
        _resultMap.value[pageIdx] = idx;
        // if (_resultMap.value[pageIdx] == idx) {
        //   _resultMap.value[pageIdx] = -1;
        // } else {
        //   _resultMap.value[pageIdx] = idx;
        // }
      });
    }
  }
}
