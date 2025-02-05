import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/utils/text_style.dart';

class NoNetworkPage extends StatefulWidget{
  const NoNetworkPage({super.key});

  @override
  State<StatefulWidget> createState() => _NoNetworkPage();

}

class _NoNetworkPage extends State<NoNetworkPage> {

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      WDCommon().toast(context, '네트워크에 연결해주세요', isError: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '앗! 화면이 이상해요',
            style: Styler.style(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 2.6,
                letterSpacing: -0.5),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            '네트워크에 연결해주세요!',
            style: Styler.style(
                color: WDColors.noNetworkColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 2.6,
                letterSpacing: -0.5),
          ),
          const SizedBox(
            height: 4,
          ),
          SizedBox(
            width: 152,
            height: 152,
            child: Image.asset('assets/images/ic_network.png'),
          )
        ],
      ),
    );
  }
}
