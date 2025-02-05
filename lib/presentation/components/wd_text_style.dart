import 'package:flutter/material.dart';

class AppTextStyles {
  static const String fontFamily = 'Helvetica';
  static const String naverNanum = 'NaverNanumSquareVar';
  static const String pretendard = 'pretendard';
  /// Text style for body
  
  static TextStyle heading1 (Color color) =>  TextStyle(
    color: color,
    fontSize: 22,
    letterSpacing: -0.32,
    wordSpacing: 1.3,
    fontWeight: FontWeight.w600,
    fontFamily: pretendard
  );

  static TextStyle heading2 (Color color) =>  TextStyle(
    color: color,
    fontSize: 20,
    letterSpacing: -0.32,
    wordSpacing: 1.4,
    fontWeight: FontWeight.w600,
    fontFamily: pretendard
  );

  static TextStyle heading3 (Color color) =>  TextStyle(
    color: color,
    fontSize: 18,
    letterSpacing: -0.32,
    wordSpacing: 1.4,
    fontWeight: FontWeight.w600,
    fontFamily: pretendard
  );

  static  TextStyle body1 (Color color) =>  TextStyle(
    color: color,
    fontSize: 16,
    letterSpacing: -0.32,
    wordSpacing: 1.5,
    fontWeight: FontWeight.w600,
    fontFamily: pretendard
  );

  static  TextStyle body2 (Color color) =>  TextStyle(
    color: color,
    fontSize: 16,
    letterSpacing: -0.32,
    wordSpacing: 1.5,
    fontWeight: FontWeight.w500,
    fontFamily: pretendard
  );

  static TextStyle body3 (Color color) =>  TextStyle(
    color: color,
    fontSize: 16,
    letterSpacing: -0.32,
    wordSpacing: 1.5,
    fontWeight: FontWeight.w400,
    fontFamily: pretendard
  );

  static TextStyle body4 (Color color) =>  TextStyle(
    color: color,
    fontSize: 15,
    letterSpacing: -0.32,
    wordSpacing: 1.5,
    fontWeight: FontWeight.w500,
    fontFamily: pretendard
  );

  static TextStyle body5 (Color color) =>  TextStyle(
    color: color,
    fontSize: 15,
    letterSpacing: -0.32,
    wordSpacing: 1.5,
    fontWeight: FontWeight.w400,
    fontFamily: pretendard
  );

  static TextStyle body6 (Color color) =>  TextStyle(
    color: color,
    fontSize: 14,
    letterSpacing: -0.32,
    wordSpacing: 1.5,
    fontWeight: FontWeight.w500,
    fontFamily: pretendard
  );

  static TextStyle detail1 (Color color) =>  TextStyle(
    color: color,
    fontSize: 13,
    letterSpacing: -0.32,
    wordSpacing: 1.5,
    fontWeight: FontWeight.w600,
    fontFamily: pretendard
  );

  static TextStyle detail2 (Color color) =>  TextStyle(
    color: color,
    fontSize: 12,
    letterSpacing: -0.32,
    wordSpacing: 1.5,
    fontWeight: FontWeight.w400,
    fontFamily: pretendard
  );

  
  static const TextStyle naverNanumBlack22 = TextStyle(
    fontSize: 22,
    color: Colors.black87,
    fontFamily: naverNanum
  );

  static const TextStyle naverNanumBlack20 = TextStyle(
    fontSize: 20,
    height: 1.2,
    color: Colors.black87,
    fontFamily: naverNanum
  );

  static const TextStyle naverNanumWhite20 = TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontFamily: naverNanum
  );

  static const TextStyle naverNanumBlack18 = TextStyle(
      fontSize: 18,
      color: Colors.black87,
      fontFamily: naverNanum,
      height: 1.5
  );

  static const TextStyle naverNanumBlack16 = TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontFamily: naverNanum
  );

  static const TextStyle naverNanumWhite16 = TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontFamily: naverNanum
  );

  static const TextStyle naverNanumWhite16B = TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontFamily: naverNanum,
      fontWeight: FontWeight.bold
  );

  static const TextStyle naverNanumBlack16B = TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontFamily: naverNanum,
      fontWeight: FontWeight.bold
  );

  static const TextStyle naverNanumBlackB22 = TextStyle(
    fontSize: 22,
    color: Colors.black87,
    fontWeight: FontWeight.bold,
    fontFamily: naverNanum
  );

}
