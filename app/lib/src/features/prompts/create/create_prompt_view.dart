import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/dm.dart';
import 'package:ollamb/src/features/prompts/create/create_prompt_vm.dart';
import 'package:ollamb/src/widgets/show_modal.dart';
import 'package:ollamb/src/widgets/style.dart';
import 'package:wee_kit/wee_kit.dart';

class CreatePromptView extends StatelessWidget {
  final int type;
  final VoidCallback onCreated;
  const CreatePromptView({required this.type, required this.onCreated, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CreatePromptVm(DM.promptStorage),
      builder: (vm) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Create Prompt", style: textHeader),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: DropdownButtonFormField(
                  value: type == 1 ? "system" : "user",
                  items: const [
                    DropdownMenuItem(value: "system", child: Text("System")),
                    DropdownMenuItem(value: "user", child: Text("User")),
                  ],
                  onChanged: (v) => vm.type = v!,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    label: Text("Type"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: vm.nameCtrl,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    label: Text("Name"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: vm.promptCtrl,
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      label: Text("Prompt"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).hoverColor,
                  foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
                ),
                onPressed: () async {
                  if (vm.nameCtrl.text.isEmpty || vm.promptCtrl.text.isEmpty) {
                    showNotif(context: context, title: "Error", content: const Text("Name & Prompt required"));
                    return;
                  }
                  await vm.create();
                  if (!context.mounted) return;
                  WeeShow.loadingOverlay(context);
                  await Future.delayed(const Duration(seconds: 1));
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  vm.reset();
                  showNotif(context: context, title: "Success", content: const Text("Prompt created"));
                  onCreated();
                },
                child: const Text("Create"),
              )
            ],
          ),
        );
      },
    );
  }
}
