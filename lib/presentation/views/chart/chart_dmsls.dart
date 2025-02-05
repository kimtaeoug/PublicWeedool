import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weedool/component/wd_appbar.dart';
import 'package:weedool/component/wd_physical_test_chart.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_text_style.dart';
import 'package:weedool/controllers/chart/controller_chart_dmsls.dart';
import 'package:weedool/models/chart/model_chart_dmsls.dart';
import 'package:weedool/utils/ga_util.dart';
import 'package:weedool/views/loading_page.dart';

class ChartDmslsView extends StatefulWidget {
  const ChartDmslsView({Key? key}) : super(key: key);

  @override
  State<ChartDmslsView> createState() => _ChartDmslsState();
}

class _ChartDmslsState extends State<ChartDmslsView> {
  double height = 0;
  double width = 0;

  ChartDmslsCtl chartDmslsCtl = ChartDmslsCtl();

  late Future<ChartDmslsModel> _chartDmslsModel;

  @override
  void initState() {
    GaUtil().trackScreen('DMSLSChartPage', input: {'uuid' : WDCommon().uuid});
    super.initState();
    if (!chartDmslsCtl.isLoading) {
      setState(() {
        chartDmslsCtl.isLoading = true;
      });
    }
    _chartDmslsModel = chartDmslsCtl.requestChartDmsls().then((value) {
      setState(() {
        chartDmslsCtl.isLoading = false;
      });
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;
    return Scaffold(
      backgroundColor: WDColors.backgroundColor,
      body: MediaQuery(
          data:
          MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: Stack(children: [
            FutureBuilder(
              future: _chartDmslsModel,
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  return Container();
                } else if (snapshot.hasError) {
                  return Container();
                } else {
                  if (snapshot.data!.data!.isEmpty) {
                    return Column(
                      children: [
                        _headerContents(),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _headerContents(),
                        _bodyContents(snapshot.data!),
                      ],
                    );
                  }
                }
              },
            ),
            LoadingPage(isLoading: chartDmslsCtl.isLoading)
          ])),
    );
  }

  Widget _headerContents() {
    return WDAppbar(
      buildContext: context,
      text: '심리검사 요약',
    );
  }

  Widget _bodyContents(ChartDmslsModel chartDmslsModel) {
    String strScore =
        '${chartDmslsModel.data![chartDmslsModel.data!.length - 1].total_score}점';
    String strContent =
        '${chartDmslsModel.data![chartDmslsModel.data!.length - 1].description}';
    List<Data> dataList = chartDmslsModel.data!.reversed.toList();
    List<Data> result = [];
    for (Data data in dataList.reversed) {
      result.add(data);
      if (result.length == 4) {
        break;
      }
    }
    return Container(
        margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(
              width: width,
              child: Text('최근 검사결과',
                  textAlign: TextAlign.left,
                  style: AppTextStyles.body6(WDColors.alternative)),
            ),
            Container(
              width: width,
              margin: const EdgeInsets.only(top: 10),
              child: Text(strScore,
                  textAlign: TextAlign.left,
                  style: AppTextStyles.heading1(WDColors.black).copyWith(
                    fontSize: 24,
                  )),
            ),
            Container(
              width: width,
              margin: const EdgeInsets.only(top: 12),
              child: Text(strContent,
                  textAlign: TextAlign.left,
                  style: AppTextStyles.body4(WDColors.neutral)
                      .copyWith(fontWeight: FontWeight.w400)),
            ),
            const SizedBox(
              height: 50,
            ),
            WDPhysicalTestChart(
              data: result,
              horizontalPadding: 0,
            )
          ],
        ));
  }
}
