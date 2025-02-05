import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_terms.dart';
import 'package:weedool/components/wd_text_style.dart';

class TermsDetailView extends StatefulWidget {
  final int termStatus;

  const TermsDetailView({Key? key, required this.termStatus}) : super(key: key);
  @override
  State<TermsDetailView> createState() => _TermsDetailState();
}

class _TermsDetailState extends State<TermsDetailView> {
  double height = 0;
  double width = 0;

  late ScrollController _controller;

  bool btnEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.termStatus == 1) {
      btnEnabled = true;
    }
    _controller = ScrollController();
    _controller.addListener(() {
      setState(() {
        btnEnabled =
            _controller.position.pixels == _controller.position.maxScrollExtent;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;
    return Scaffold(
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Column(
        children: [_headerContents(), _bodyContents(), _footContents()],
      ),
    ));
  }

  Widget _headerContents() {
    return Container(
      margin: const EdgeInsets.only(top: 66),
      height: 34,
      width: width,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              icon: Image.asset('assets/images/ic_close.png',
                  width: 16, height: 16, fit: BoxFit.contain),
            ),
          )
        ],
      ),
    );
  }

  Widget _bodyContents() {
    String title = '';
    String content = '';

    switch (widget.termStatus) {
      case 0:
        title = 'WeeDool 서비스 이용약관';
        content = serviceTerms;
        break;
      case 1:
        title = '개인정보 수집 및 이용 동의서';
        content = agreeTerms;
        break;
      case 2:
        title = '개인정보 처리 방침';
        content = policyTerms;
      case 3:
        title = '마케팅정보 수신동의';
        content = marketingTerms;
        break;
    }

    return SizedBox(
        width: width,
        height: height - 160,
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: _controller,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    style: AppTextStyles.heading2(WDColors.black),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    content,
                    textAlign: TextAlign.left,
                    style: AppTextStyles.body3(WDColors.black),
                  ),
                ],
              ),
            )));
  }

  Widget _footContents() {
    return GestureDetector(
        onTap: () {
          if (btnEnabled) {
            Navigator.pop(context, true);
          }
        },
        child: Container(
          width: width,
          height: 60,
          decoration: BoxDecoration(
              color: btnEnabled
                  ? const Color(0xFF41A8D7)
                  : const Color(0xFFE8E8E8)),
          child: Center(
              child: Text(
            '동의',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading3(
                btnEnabled ? WDColors.white : WDColors.black),
          )),
        ));
  }
}
