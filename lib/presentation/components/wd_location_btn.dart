import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class WDLocationBtn extends StatelessWidget {
  final Function() function;

  WDLocationBtn({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: function,
        child: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '가까운 센터를 확인해볼까요?',
                    style: Styler.style(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 14,),
                  Container(
                    width: 106,
                    height: 46,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: WDColors.primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        '위치 허용',
                        style: Styler.style(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              //main_motion_004.png
              SizedBox(
                width: 80,
                height: 80,
                child: Image.asset('assets/images/main_motion_004.png'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
