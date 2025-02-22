import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_repository.dart';
import 'package:ollamb/src/widgets/style.dart';
import 'package:wee_kit/wee_kit.dart';
import 'import_vm.dart';

class ImportView extends StatelessWidget {
  final VoidCallback onImport;
  final OllamaRepository ollamaRepository;
  const ImportView({super.key, required this.onImport, required this.ollamaRepository});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<OllamaGuiModelImportVm>(
        init: OllamaGuiModelImportVm(ollamaRepository, Core.fileService),
        builder: (vm) {
          return Container(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        onChanged: (value) => vm.update(),
                        controller: vm.modelNameController,
                        decoration: const InputDecoration(
                          label: Text("Model Name"),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "Mario",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        onChanged: (value) => vm.update(),
                        controller: vm.modelTagController,
                        decoration: const InputDecoration(label: Text("Tag"), floatingLabelBehavior: FloatingLabelBehavior.always, hintText: "latest", prefixText: ":"),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: activeColor(context, vm.importMethod == 0)),
                      onPressed: () {
                        vm.importMethod = 0;
                        vm.update();
                      },
                      child: const Text("WRITE"),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextButton(
                        style: TextButton.styleFrom(foregroundColor: activeColor(context, vm.importMethod == 1)),
                        onPressed: kIsWeb
                            ? null
                            : () {
                                vm.importMethod = 1;
                                vm.update();
                              },
                        child: const Tooltip(message: kIsWeb ? "Unsupported platform" : "", child: Text("UPLOAD")),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    child: vm.importMethod == 0
                        ? TextField(
                            expands: true,
                            onChanged: (value) => vm.update(),
                            focusNode: vm.modelFileFocusNode,
                            keyboardType: TextInputType.multiline,
                            controller: vm.modelFileController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              filled: true,
                              border: InputBorder.none,
                              hintText: "FROM model.gguf",
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (vm.modelFilePath != null) Text(vm.modelFilePath!.name),
                                const SizedBox(height: 16),
                                OutlinedButton.icon(
                                  onPressed: kIsWeb ? null : () => vm.selectModelFile(context),
                                  label: const Text("ModelFile"),
                                  icon: !kIsWeb
                                      ? null
                                      : const Tooltip(
                                          message: "Unsupported platform, Please copy file path manually",
                                          child: Icon(Icons.info_outline, size: 16),
                                        ),
                                )
                              ],
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: !vm.isValid
                          ? null
                          : () async {
                              WeeShow.loadingOverlay(context);
                              try {
                                await vm.import();
                                if (!context.mounted) return;
                                Navigator.pop(context);
                                onImport();
                                showNotif(context, "Import Successful", "The model has been successfully imported to the Ollama server.");
                              } catch (e) {
                                Navigator.pop(context);
                                String message;
                                try {
                                  final errorMap = jsonDecode(e.toString()) as Map<String, dynamic>;
                                  message = errorMap['error']?.toString() ?? "An unknown error occurred.";
                                } catch (decodeError) {
                                  message = "An unexpected error occurred: $e";
                                }
                                showNotif(context, "Import Failed", message);
                              }
                            },
                      child: const Text("Import"),
                    ),
                    TextButton(onPressed: vm.reset, child: const Text("Reset")),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void showNotif(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }
}
