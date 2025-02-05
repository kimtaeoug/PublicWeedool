import 'package:flutter/cupertino.dart';

class SplashAnimation extends StatelessWidget {
  final Animation<double> controller;
  final Animation<AlignmentDirectional> alignment;
  final Animation<double> opacity;

  SplashAnimation({Key? key, required this.controller})
      : alignment = Tween<AlignmentDirectional>(
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.center)
            .animate(CurvedAnimation(
                parent: controller,
                curve: const Interval(0, 0.9, curve: Curves.bounceOut))),
        opacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
            parent: controller, curve: Interval(0, 0.9, curve: Curves.linear))),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Align(
            alignment: alignment.value,
            child: Opacity(
              opacity: opacity.value,
              child: loadSplash(),
            ),
          );
        });
  }

  Widget loadSplash() {
    return Image.asset('assets/images/ic_splash_logo.png',
        width: 74, height: 50);
  }
}
