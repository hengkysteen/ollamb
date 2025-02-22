import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_vm.dart';

import 'package:ollamb/src/core/modules/conversation/view_models/conversation_vm.dart';

class MetaVm extends GetxController {
  final FocusNode renameNode = FocusNode();

  String renameTitle = '';
  void setRenameTitle(String value) {
    renameTitle = value;
    update();
  }

  Future<void> getMetaDetail(String id) async {
    if(ConversationVm.find.conversation?.id == id)return;
    final data = await ConversationVm.find.getConversation(id);
    Core.layout.changeTab(0, data: id);

    ConversationVm.find.setConversation(data);

    if (data != null) {
      final lastModel = data.messages.isNotEmpty ? data.messages.last.model : null;
      final model = OllamaVm.find.server.models.firstWhereOrNull((e) => e.name == lastModel);
      if (model != null) {
        OllamaVm.find.setModel(model.name);
      }
    }

    setRenameTitle("");

    Future.delayed(const Duration(milliseconds: 50), () {
      renameNode.unfocus();
      Core.bodyNode.requestFocus();
    });
  }
}
