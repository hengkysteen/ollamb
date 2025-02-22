import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/core/modules/conversation/models/message.dart';
import 'package:ollamb/src/core/modules/conversation/view_models/conversation_vm.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_vm.dart';
import 'package:ollamb/src/features/model_options/model_options_vm.dart';

class InputVm extends GetxController {
  final OllamaVm ollamaVm;

  InputVm(this.ollamaVm);
  final TextEditingController textEditingController = TextEditingController();

  /// Document attachment
  Map<String, dynamic>? document;

  /// Image attachment
  String? image;

  final FocusNode inputFocusNode = FocusNode(
    onKeyEvent: (node, event) {
      return Core.keyboard.prosesWithResult(
        [
          Core.keyboard.holdShiftLeft(key: LogicalKeyboardKey.enter, event: event, callback: InputVm.find.send),
        ],
      );
    },
  );

  void setDocument(Map<String, dynamic>? data) {
    document = data;
    update();
  }

  void setImage(String? base64) {
    image = base64;
    update();
  }

  void stop() {
    ConversationVm.find.stopMessage();
  }

  void send() {
    if (ConversationVm.find.message != null) {
      stop();
    }
    if (textEditingController.text.isEmpty) return;
    if (ollamaVm.model == null) return;

    final ModelOptionsVm optionsVm = ModelOptionsVm.find;

    final Map<String, dynamic>? documentPrompt = document;
    final String? imagePrompt = image;
    setImage(null);
    setDocument(null);

    final prompt = Prompt(text: textEditingController.text.trim(), image: imagePrompt, document: documentPrompt);
    final system = optionsVm.isActivate && optionsVm.systemPrompt.trim().isNotEmpty ? optionsVm.systemPrompt : null;
    final model = ollamaVm.model!.name;
    final options = optionsVm.isActivate && !optionsVm.isOptionsEqual ? optionsVm.options : null;
    final keepAlive = optionsVm.isActivate
        ? optionsVm.keepAlive == "5m"
            ? null
            : optionsVm.keepAlive
        : null;

    ConversationVm.find.sendMessage(
      prompt,
      model,
      system: system,
      options: options,
      keepAlive: keepAlive,
      onConversationCreate: (c) {
        if (Core.platform.isMobile) return;
        Core.layout.changeTab(0, data: c.id);
      },
    );
    textEditingController.clear();
  }

  static InputVm get find => Get.find();
}
