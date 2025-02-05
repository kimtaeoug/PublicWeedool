import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weedool/utils/keyboard_util.dart';

class LoadingPage extends StatelessWidget {
  final bool isLoading;

  const LoadingPage({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return isLoading
        ? GestureDetector(
            onTap: () {},
            child: Container(
              width: size.width,
              height: size.height,
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: SizedBox(
                  height: KeyboardUtil.keyboardOpen()
                      ? 70 : 100,
                  child: Lottie.asset('assets/json/loading_animation.json',
                      fit: BoxFit.fitHeight, renderCache: RenderCache.raster),
                ),
              ),
            ),
          )
        : Container();
  }
}
