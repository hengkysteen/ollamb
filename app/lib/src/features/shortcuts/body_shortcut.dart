import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/core/modules/conversation/view_models/conversation_vm.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_vm.dart';
import 'package:ollamb/src/features/conversation/input/input_vm.dart';
import 'package:ollamb/src/features/model_list/model_list_view.dart';
import 'package:ollamb/src/features/model_options/model_options_view.dart';
import 'package:ollamb/src/features/prompts/prompts_view.dart';
import 'package:ollamb/src/services/keyboard_shortcuts.dart';
import 'package:wee_kit/wee_kit.dart';

class BodyShortcut {
  final KeyboardShortcuts _shortcuts;
  BodyShortcut(this._shortcuts);

  /// Body Focus
  KeyEventResult Function(FocusNode, KeyEvent)? listen(BuildContext context) {
    return (node, event) {
      // Ignore when another focus active
      if (FocusManager.instance.primaryFocus != Core.bodyNode) return KeyEventResult.ignored;

      return _shortcuts.prosesWithResult(
        [
          // SHIFT LEFT + RIGHT OR LEFT  = TOGGLE SIDEBAR
          _shortcuts.holdShiftLeft(
            key: LogicalKeyboardKey.arrowRight,
            orKey: LogicalKeyboardKey.arrowLeft,
            event: event,
            callback: Core.layout.toggleCollapse,
          ),
          // SHIFT LEFT + C = NEW CONVERSATION
          _shortcuts.holdShiftLeft(
            key: LogicalKeyboardKey.keyC,
            event: event,
            callback: () {
              if (Core.layout.tab.index == 0 || Core.layout.tab.index == 1) {
                ConversationVm.find.setConversation(null);
                Core.layout.changeTab(0);
              }
            },
          ),
          // SHIFT LEFT + S = SHOW MENUS
          _shortcuts.holdShiftLeft(
            key: LogicalKeyboardKey.keyS,
            event: event,
            callback: () {
              WeeShow.bluredDialog(context: context, child: Core.menusPage);
            },
          ),
          // SHIFT LEFT + D = SHOW MODELS
          _shortcuts.holdShiftLeft(
            key: LogicalKeyboardKey.keyD,
            event: event,
            callback: () {
              if (Core.layout.tab.index == 0 || Core.layout.tab.index == 1) {
                showModalBottomSheet(context: context, builder: (context) => const ModelListView());
              }
            },
          ),
          // SHIFT LEFT + A = SHOW MODELS OPTIONS
          _shortcuts.holdShiftLeft(
            key: LogicalKeyboardKey.keyA,
            event: event,
            callback: () {
              if (OllamaVm.find.model == null) return;
              WeeShow.bluredDialog(context: context, child: const ModelOptionsView());
            },
          ),
          // USER PROMPTS KEYBOARD SHORTCUT TODO @features/prompts
          // SHIFT LEFT + F = SHOW PROMPTS
          _shortcuts.holdShiftLeft(
            key: LogicalKeyboardKey.keyF,
            event: event,
            callback: () {
              WeeShow.bluredDialog(
                context: context,
                child: PromptsCollectionsView(
                  type: 2,
                  onSelect: (data) {
                    InputVm.find.textEditingController.text = data;
                    InputVm.find.inputFocusNode.requestFocus();
                  },
                ),
              );
            },
          ),
        ],
      );
    };
  }
}
