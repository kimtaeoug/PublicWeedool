import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:weedool/utils/logger.dart';

///
/// Asset에 있는 이미지를 캐시에 미리 올림
///
class ImgUtil{
  static void _cachePng(String input, BuildContext context) async {
    await precacheImage(AssetImage(input), context);
  }

//asset에 있는 이미지들 미리 cache
  static void precacheImageFromAsset(BuildContext context) async {
    try {
      Map<String, dynamic> manifestMap = json.decode(await rootBundle.loadString('AssetManifest.json'));
      for (var element in manifestMap.keys) {
        if (element.contains('.png')) {
          _cachePng(element, context);
        }
      }
    } catch (e) {
      WDLog.e('Error : $e in precacheImageFromAsset');
    }
  }
}