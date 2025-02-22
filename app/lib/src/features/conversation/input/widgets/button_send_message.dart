import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/modules/conversation/view_models/conversation_vm.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_vm.dart';
import 'package:ollamb/src/features/conversation/input/input_vm.dart';

class SendMessageButton extends StatelessWidget {
  final TextEditingController textEditingController;
  const SendMessageButton({super.key, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OllamaVm>(
      builder: (ollamaVm) {
        return GetBuilder<ConversationVm>(
          builder: (vm) {
            if (vm.isMessageStart) {
              return CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: InputVm.find.stop,
                child: const Icon(CupertinoIcons.stop),
              );
            }

            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: ollamaVm.model == null
                  ? null
                  : () {
                      InputVm.find.send();
                      FocusScope.of(context).requestFocus(InputVm.find.inputFocusNode);
                    },
              child: const Icon(CupertinoIcons.paperplane),
            );
          },
        );
      },
    );
  }
}
