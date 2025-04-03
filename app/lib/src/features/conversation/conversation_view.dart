import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/core/modules/conversation/view_models/conversation_vm.dart';
import 'package:ollamb/src/core/modules/preferences/preferences_vm.dart';
import 'package:ollamb/src/features/conversation/message/message_view.dart';
import 'package:ollamb/src/features/conversation/message/message_vm.dart';
import 'package:ollamb/src/features/conversation/welcome_view.dart';

class ConversationView extends StatelessWidget {
  const ConversationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConversationVm>(
      builder: (vm) {
        if (vm.conversation == null) return const WelcomeView();
        if (vm.messages.isEmpty) return const Center(child: Text("No Messages"));
        return Container(
          margin: EdgeInsets.symmetric(horizontal: (PreferencesVm.find.getPadding(context) - 10)),
          child: GetBuilder<MessageVm>(
            init: MessageVm(Core.tts),
            builder: (_) {
              return SelectionArea(
                child: GestureDetector(
                  onTap: Core.bodyNode.requestFocus,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    reverse: true,
                    itemCount: vm.messages.length,
                    itemBuilder: (context, index) {
                      final message = vm.messages[index];
                      return MessageView(key: ValueKey(message.id), message);
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
