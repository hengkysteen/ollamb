import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/features/ollama_gui/model_copy/copy_vm.dart';
import 'package:wee_kit/wee_kit.dart';

class OGuiModelCopyView extends StatelessWidget {
  final String model;
  final void Function(String newModel) onSuccess;
  final void Function(String? error) onError;

  const OGuiModelCopyView(this.model, {super.key, required this.onSuccess, required this.onError});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OGuiModelCopyVm>(
      init: OGuiModelCopyVm(),
      builder: (vm) {
        return AlertDialog(
          title: const Text("Copy Model"),
          content: Container(
            constraints: const BoxConstraints(maxWidth: 350),
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Copy from $model"),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: vm.modelNameCtrl,
                        decoration: const InputDecoration(
                          label: Text("Model Name"),
                          hintText: "Mario",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: vm.modelTagCtrl,
                        decoration: const InputDecoration(
                          prefix: Text(":"),
                          hintText: "latest",
                          label: Text("Tags"),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Delete Original ?"),
                Transform.scale(
                  scale: 0.7,
                  child: Switch.adaptive(
                      value: vm.deleteOriginalModel,
                      onChanged: (_) {
                        vm.toggleDeleteOriginalModel();
                      }),
                ),
              ],
            ),
            TextButton(
              onPressed: () async {
                if (vm.newModelName.trim().isEmpty) return;
                Navigator.pop(context);
                WeeShow.loadingOverlay(context, loadingText: "Copy model ...");
                try {
                  await vm.copy(model);
                  onSuccess(vm.newModelName);
                } catch (e) {
                  onError(e.toString());
                }
              },
              child: const Text("Copy"),
            )
          ],
        );
      },
    );
  }
}
