import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_text_style.dart';

import 'package:weedool/controllers/reserve/controller_counselor_info.dart';
import 'package:weedool/models/reserve/model_counselor_info.dart';
import 'package:weedool/views/loading_page.dart';

class CounselorInfoView extends StatefulWidget {
  final String center_id;
  final String counsler_id;

  const CounselorInfoView(
      {Key? key, required this.center_id, required this.counsler_id})
      : super(key: key);

  @override
  State<CounselorInfoView> createState() => _CounselorInfoState();
}

//todo
//counselor 수정
class _CounselorInfoState extends State<CounselorInfoView> {
  double height = 0;
  double width = 0;

  CounselorInfoCtl counselorInfoCtl = CounselorInfoCtl();

  final ValueNotifier<CounselorInfoModel?> _counselor = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!counselorInfoCtl.isLoading) {
        setState(() {
          counselorInfoCtl.isLoading = true;
        });
      }
      _counselor.value = await counselorInfoCtl.requestCounselorInfo(
          widget.center_id, widget.counsler_id);
      setState(() {
        counselorInfoCtl.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;
    return Scaffold(
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Stack(children: [
        ValueListenableBuilder(
            valueListenable: _counselor,
            builder: (_, value, child) {
              if (value != null) {
                return SingleChildScrollView(
                  child: Column(
                    children: [_headerContents(value!), _bodyContents(value!)],
                  ),
                );
              } else {
                return Container();
              }
            }),
        LoadingPage(isLoading: counselorInfoCtl.isLoading)
      ]),
    ));
  }

  Widget _headerContents(CounselorInfoModel counselorInfoModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(color: Color(0xffEEF4F9)),
      height: 533,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 66,
          ),
          Container(
            width: width,
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          const SizedBox(
            height: 42,
          ),
          Container(
            width: 235,
            height: 262,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://weedool-web-back.s3.ap-northeast-2.amazonaws.com/${counselorInfoModel.data!.counselor_img}'),
                    fit: BoxFit.cover),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(counselorInfoModel.data!.counselor_name,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading2(WDColors.black)),
          const SizedBox(
            height: 16,
          ),
          Container(
            decoration: const BoxDecoration(
                color: WDColors.black,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              counselorInfoModel.data!.counselor_position,
              textAlign: TextAlign.center,
              style: AppTextStyles.detail2(WDColors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _bodyContents(CounselorInfoModel counselorInfoModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/ic_counselor_check.png',
                  width: 18, height: 18, fit: BoxFit.contain),
              const SizedBox(
                width: 8,
              ),
              Text(
                '주요 경력',
                textAlign: TextAlign.center,
                style: AppTextStyles.body1(WDColors.black),
              ),
            ],
          ),
          const SizedBox(
            height: 11,
          ),
          for (var i in counselorInfoModel.data!.counselor_career!)
            Text(
              '· ${i.content}',
              textAlign: TextAlign.left,
              style: AppTextStyles.body4(const Color(0xFF555555)),
            ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/ic_counselor_check.png',
                  width: 18, height: 18, fit: BoxFit.contain),
              const SizedBox(
                width: 8,
              ),
              Text(
                '전문 분야',
                textAlign: TextAlign.center,
                style: AppTextStyles.body1(WDColors.black),
              ),
            ],
          ),
          const SizedBox(
            height: 11,
          ),
          for (var i in counselorInfoModel.data!.counselor_speciality!)
            Text(
              '· $i',
              textAlign: TextAlign.left,
              style: AppTextStyles.body4(const Color(0xFF555555)),
            ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/ic_counselor_check.png',
                  width: 18, height: 18, fit: BoxFit.contain),
              const SizedBox(
                width: 8,
              ),
              Text(
                '자격 사항',
                textAlign: TextAlign.center,
                style: AppTextStyles.body1(WDColors.black),
              ),
            ],
          ),
          const SizedBox(
            height: 11,
          ),
          for (var i in counselorInfoModel.data!.counselor_certificate!)
            Text(
              '· ${i.institution} ${i.grade}',
              textAlign: TextAlign.left,
              style: AppTextStyles.body4(const Color(0xFF555555)),
            ),
        ],
      ),
    );
  }
}
