import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:weedool/component/wd_btn.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_text_style.dart';
import 'package:weedool/controllers/test/test_controller.dart';
import 'package:weedool/models/model_checkup.dart';
import 'package:weedool/models/test/model_test_normal.dart';
import 'package:weedool/utils/ga_util.dart';
import 'package:weedool/views/test/dmsls_test_page.dart';

class TabTestView extends StatefulWidget {
  const TabTestView({Key? key}) : super(key: key);

  @override
  State<TabTestView> createState() => _TabTestState();
}

class _TabTestState extends State<TabTestView> {
  double height = 0;
  double width = 0;
  int _tabIndex = 0;
  List<NormalTest> listTest = [];
  final TestController testController = TestController();

  void setData() async {
    listTest.clear();
    if (_tabIndex == 0) {
      listTest.add(NormalTest(
          'DMSLS 검사',
          '우울정서 6단계 척도(DMSLS)는 기존 우울증 검사 척도인 PHQ-9, BDI, BDI-Ⅱ, HAMD, MADRS. CES-D 등 총 12개 우울척도를 종합하여 개발한 자가 진단 설문지 입니다. 총 30문항이며, 지난 2주간 겪었던 감정을 떠올리며 편안한 마음으로 답변하시면 됩니다.',
          '',
          '',
          false));
    } else {
      listTest.add(NormalTest(
          '로샤 검사',
          '이 그림 뭘로 보이세요?',
          '로샤 검사는 개인의 성격을 다차원적으로 이해하는데 도움을 줍니다. 개인의 인지적, 정서적, 대인관계 방식과 자기 상 등 다양하고 종합적인 정보를 제공합니다.',
          'img_draw_test.png',
          false));
    }
    _checkupModel = await testController.requestCheckup('DMSLS');
  }

  CheckupModel? _checkupModel = null;

  @override
  void initState() {
    GaUtil().trackScreen('TestPage', input: {'uuid': WDCommon().uuid});
    super.initState();
    setData();
  }

  //    final MediaQueryData data = MediaQuery.of(context);
  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    height == 0 ? height = data.size.height : 0;
    width == 0 ? width = data.size.width : 0;
    return Scaffold(
        body: MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaler: data.textScaleFactor > 1 ? null : TextScaler.noScaling),
      child: SizedBox(
        width: width,
        height: height - 110,
        child: SingleChildScrollView(
          child: Column(
            children: [_headerContents(), _bodyContents()],
          ),
        ),
      ),
    ));
  }

  Widget _headerContents() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 14),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: width,
      child: Align(
        alignment: Alignment.center,
        child: Text('검사',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading3(WDColors.black)),
      ),
    );
  }

  Widget _bodyContents() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: width,
      child: SizedBox(
        width: width,
        child: _item(0),
      ),
    );
  }

  Widget _item(int index) {
    return Container(
      width: width - 40,
      margin: const EdgeInsets.only(top: 28),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: WDColors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6)
        ],
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                listTest[index].title,
                style: AppTextStyles.heading3(WDColors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                margin: const EdgeInsets.only(top: 6),
                child: Text(
                  listTest[index].subTitle,
                  style: AppTextStyles.body4(WDColors.alternative),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            WDBtn(
                text: '검사하기',
                width: width,
                height: 52,
                function: () {
                  if (_checkupModel != null) {
                    if (_checkupModel?.data.mcq_flag == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DmslsTestPage(category: 'DMSLS')),
                      );
                    } else {
                      WDCommon().toast(
                          context, '아직 문진을 진행할 시간이 아니에요. 4주가 지난 후에 진행하실 수 있습니다',
                          isError: true);
                    }
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget _setList() {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: listTest.length,
        itemBuilder: (context, index) {
          return _addItem(index);
        });
  }

  Widget _addItem(int index) {
    return Container(
      width: width - 40,
      margin: const EdgeInsets.only(top: 28),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: WDColors.white,
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 1),
        ],
      ),
      child: Container(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 19, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              listTest[index].title,
              style: AppTextStyles.heading3(WDColors.black),
            ),
            Container(
              margin: const EdgeInsets.only(top: 6),
              child: Text(
                listTest[index].subTitle,
                style: AppTextStyles.body4(WDColors.alternative),
              ),
            ),
            listTest[index].visibility
                ? Container(
                    margin: const EdgeInsets.only(top: 18),
                    child: Text(
                      listTest[index].description,
                      style: AppTextStyles.detail2(WDColors.black),
                    ),
                  )
                : Container(),
            listTest[index].visibility
                ? SizedBox(
                    width: width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          listTest[index].imageUrl != ''
                              ? Container(
                                  margin: const EdgeInsets.only(top: 24),
                                  child: Image.asset(
                                      'assets/images/${listTest[index].imageUrl}',
                                      width: 242,
                                      height: 164,
                                      fit: BoxFit.contain))
                              : Container(),
                          GestureDetector(
                              onTap: () {
                                if (_checkupModel != null) {
                                  if (_checkupModel?.data.mcq_flag == true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DmslsTestPage(category: 'DMSLS')),
                                    );
                                  } else {
                                    WDCommon().toast(context,
                                        '아직 문진을 진행할 시간이 아니에요. 4주가 지난 후에 진행하실 수 있습니다',
                                        isError: true);
                                  }
                                }
                              },
                              child: Container(
                                  width: 149,
                                  height: 41,
                                  margin: const EdgeInsets.only(
                                      top: 25, bottom: 13),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF41A8D7),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Center(
                                      child: Text(
                                    '검사 시작하기',
                                    style: AppTextStyles.body1(WDColors.white),
                                  ))))
                        ]),
                  )
                : Container(),
            Container(
              width: width - 40 - 48,
              margin: const EdgeInsets.only(top: 16),
              height: 1,
              decoration: const BoxDecoration(color: Color(0xFFC6C6C6)),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    listTest[index].visibility =
                        listTest[index].visibility ? false : true;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          listTest[index].visibility ? '접기' : '더보기',
                          style: AppTextStyles.body6(const Color(0xFF7E7E7E)),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 7),
                            child: Image.asset(
                                listTest[index].visibility
                                    ? 'assets/images/ic_test_arrow_top.png'
                                    : 'assets/images/ic_test_arrow_bottom.png',
                                width: 9,
                                height: 5,
                                fit: BoxFit.contain)),
                      ]),
                ))
          ],
        ),
      ),
    );
  }
}
