import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show KeyEventResult;

class KeyboardShortcuts {
  KeyEventResult prosesWithResult(List<KeyEventResult> shortcuts) {
    for (var action in shortcuts) {
      if (action == KeyEventResult.handled) {
        action;
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult holdShiftLeft({required LogicalKeyboardKey key, LogicalKeyboardKey? orKey, required KeyEvent event, required VoidCallback callback}) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == key || (orKey != null && event.logicalKey == orKey)) {
        if (HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
          callback();
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }
}
