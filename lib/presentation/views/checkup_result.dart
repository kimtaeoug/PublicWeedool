import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_constants.dart';
import 'package:weedool/components/wd_text_style.dart';
import 'package:weedool/models/model_checkup_add.dart';
import 'package:weedool/views/home.dart';

class CheckupResultView extends StatefulWidget {
  final CheckupAddModel? checkupAddModel;
  final String? category;

  const CheckupResultView({super.key, this.checkupAddModel, this.category});

  @override
  State<CheckupResultView> createState() => _CheckupResultState();
}

class _CheckupResultState extends State<CheckupResultView> {
  double height = 0;
  double width = 0;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      WDCommon().dmsls_flag = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;
    return PopScope(canPop: false, onPopInvoked: (_) {}, child: _body());
  }

  Widget _body() {
    return Scaffold(
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: _bodyContents(),
    ));
  }

  Widget _bodyContents() {
    if (widget.category! == 'INTAKE') {
      return Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(24),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 116 + MediaQuery.of(context).padding.top,
                ),
                Text('수고하셨습니다!',
                    textAlign: TextAlign.left,
                    style: AppTextStyles.heading1(WDColors.black)),
                Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 40),
                    child: Text('회원님께 딱 맞는 정보를 제공해드릴게요.',
                        textAlign: TextAlign.left,
                        style: AppTextStyles.body2(WDColors.gray))),
                Center(
                  child: Image.asset('assets/images/back_intake_result.gif',
                      width: 280, height: 280, fit: BoxFit.contain),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 47),
                  child: GestureDetector(
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
                          decoration: const BoxDecoration(
                              color: Color(0xFF3E9CE2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Center(
                            child: Text('네!',
                                textAlign: TextAlign.left,
                                style: AppTextStyles.heading3(WDColors.white)),
                          ))),
                )
              ]));
    } else {
      return Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/back_dmsls_res.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Container(
              width: width,
              height: height - 135,
              padding: const EdgeInsets.only(top: 45, left: 27, right: 27),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 83),
                        child: Text(
                            widget.checkupAddModel!.data.result!.user_level,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.heading1(WDColors.white)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Text(
                            widget.checkupAddModel!.data.result!.description,
                            textAlign: TextAlign.left,
                            style: AppTextStyles.body4(WDColors.white)),
                      ),
                      Container(
                        width: width,
                        margin: const EdgeInsets.only(top: 56),
                        child: Text('추천 활동 목록',
                            textAlign: TextAlign.left,
                            style: AppTextStyles.body1(WDColors.white)),
                      ),
                      Container(
                        width: width,
                        margin: const EdgeInsets.only(top: 16),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(0),
                          itemCount: widget.checkupAddModel!.data.result!
                              .recommend_act!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: WDColors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                '$serverImageUrl${widget.checkupAddModel!.data.result!.recommend_act![index].activity_id}.png'),
                                            fit: BoxFit.fill),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(30))),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 17),
                                    child: Text(
                                        widget.checkupAddModel!.data.result!
                                            .recommend_act![index].activity,
                                        textAlign: TextAlign.left,
                                        style: AppTextStyles.body1(
                                            WDColors.black)),
                                  ),
                                  // const Spacer(),
                                  // Image.asset(
                                  //     'assets/images/ic_chart_arrow_right.png',
                                  //     width: 7,
                                  //     height: 12,
                                  //     fit: BoxFit.contain)
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  )),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const HomeView(
                              selectedIndex: 4,
                            )),
                    (route) => false);
              },
              child: Container(
                width: width,
                height: 64,
                margin: const EdgeInsets.only(
                    top: 32, bottom: 39, left: 27, right: 27),
                decoration: const BoxDecoration(
                    color: Color(0xFF282828),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Text('확인했어요',
                      textAlign: TextAlign.left,
                      style: AppTextStyles.heading3(WDColors.white)),
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}
