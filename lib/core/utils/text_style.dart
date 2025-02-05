
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';

extension Styler on TextStyle {
  static TextStyle style(
          {double fontSize = 14,
          Color color = WDColors.black,
          FontWeight fontWeight = FontWeight.w400,
          TextDecoration? textDecoration,
          double? letterSpacing,
          double? height,}) =>
      TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          decoration: textDecoration,
          letterSpacing: letterSpacing ?? -0.32,
          height: height ?? 1.4,
          fontFamily: 'pretendard');
}
