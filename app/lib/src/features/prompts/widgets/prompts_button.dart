import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ollamb/src/features/conversation/input/input_vm.dart';
import 'package:ollamb/src/features/model_options/model_options_vm.dart';
import 'package:ollamb/src/features/prompts/prompt_view.dart';
import 'package:wee_kit/wee_kit.dart';

class SystemPromptsButton extends StatelessWidget {
  const SystemPromptsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      preferBelow: false,
      message: "Prompt Collections",
      child: IconButton(
        onPressed: () {
          WeeShow.bluredDialog(
            context: context,
            child: PromptView(
              type: 1,
              onSelect: (data) {
                ModelOptionsVm.find.systemPromptController.text = data;
                ModelOptionsVm.find.setSystemPrompt(data);
              },
            ),
          );
        },
        icon: const Icon(CupertinoIcons.doc_plaintext),
      ),
    );
  }
}

class UserPromptsButton extends StatelessWidget {
  const UserPromptsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      preferBelow: false,
      message: "Prompt Collections",
      child: InkWell(
        onTap: () {
          WeeShow.bluredDialog(
            context: context,
            child: PromptView(
              type: 2,
              onSelect: (data) {
                InputVm.find.textEditingController.text = data;
                InputVm.find.inputFocusNode.requestFocus();
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: const Center(child: Icon(CupertinoIcons.doc_plaintext, size: 16)),
        ),
      ),
    );
  }
}
