import 'dart:ui';

import 'package:flutter/cupertino.dart';

class UiUtil {
  static Size textSize(String text, TextStyle style,
      {double? maxWidth, int? maxLines}) {
    final TextPainter painter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: maxLines ?? 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: maxWidth ?? double.infinity);
    return painter.size;
  }

  static Size? widgetSize(GlobalKey key) {
    if (key.currentContext != null) {
      return (key.currentContext!.findRenderObject() as RenderBox).size;
    }
    return null;
  }

  static Offset? widgetPosition(GlobalKey key) {
    if (key.currentContext != null) {
      return (key.currentContext!.findRenderObject() as RenderBox)
          .localToGlobal(Offset.zero);
    }
    return null;
  }

  static bool isTextOverflow(
    String text,
    TextStyle style,
    double textScaleFactor, {
    double minWidth = 0,
    double maxWidth = double.infinity,
  }) {
    return (TextPainter(
            text: TextSpan(text: text, style: style),
            maxLines: null,
            textDirection: TextDirection.ltr,
            textScaleFactor: textScaleFactor)
          ..layout(minWidth: minWidth, maxWidth: maxWidth))
        .didExceedMaxLines;
  }
}
