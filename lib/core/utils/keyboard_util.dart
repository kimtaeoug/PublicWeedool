import 'package:flutter/cupertino.dart';

class KeyboardUtil {
  static bool keyboardOpen() =>
      WidgetsBinding.instance.window.viewInsets.bottom > 0;

  static closeKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
