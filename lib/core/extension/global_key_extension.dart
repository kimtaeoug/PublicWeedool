import 'package:flutter/cupertino.dart';

extension GlobalKeyExtension on GlobalKey {
  ///
  ///global position
  ///
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }

  ///
  ///  Local Position
  ///
  Offset? get localPosition {
    if (currentContext != null) {
      return (currentContext!.findRenderObject() as RenderBox)
          .globalToLocal(Offset.zero);
    }
    return null;
  }
}
