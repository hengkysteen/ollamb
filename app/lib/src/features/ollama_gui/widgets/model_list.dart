import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/core/dm.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_repository.dart';
import 'package:ollamb/src/features/ollama_gui/model_copy/copy_view.dart';
import 'package:ollamb/src/features/ollama_gui/model_export/export_vm.dart';
import 'package:ollamb/src/features/ollama_gui/ollama_gui_vm.dart';
import 'package:ollamb/src/features/ollama_gui/widgets/model_detail.dart';
import 'package:ollamb/src/widgets/model_icon.dart';
import 'package:ollamb/src/widgets/show_modal.dart';
import 'package:ollamb/src/widgets/style.dart';
import 'package:wee_kit/wee_kit.dart';
import 'dart:io';
import '../model_import/import_view.dart';

class OllamaGuiModelList extends StatelessWidget {
  final OllamaRepository ollamaRepository;
  const OllamaGuiModelList({super.key, required this.ollamaRepository});

  void onAddModel(BuildContext context, OllamaGuiVm vm) {
    WeeShow.bluredDialog(
      context: context,
      child: ImportView(
        ollamaRepository: ollamaRepository,
        onImport: () {
          vm.getModels(vm.selectedServer);
        },
      ),
    );
  }

  void onDeleteModel(BuildContext context, OllamaGuiVm vm, String model) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete Model"),
          content: Text("Are you sure to delete $model "),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                WeeShow.loadingOverlay(context, loadingText: "Deleting model ...");

                final data = await ollamaRepository.deleteModel(model);
                await Future.delayed(const Duration(seconds: 1));
                if (data) {
                  vm.removeModel(model);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  await Future.delayed(const Duration(milliseconds: 300));
                  if (!context.mounted) return;
                  showNotif(context: context, title: 'Delete Success', content: Text("$model deleted successfully"));
                } else {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  showNotif(context: context, title: 'Delete Failed', content: Text("Failed to delete $model."));
                }
              },
              child: const Text("Delete"),
            )
          ],
        );
      },
    );
  }

   bool isVersionGreater(String? current, String target) {
  if (current == null || current.isEmpty) return false;

  try {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> targetParts = target.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      int cur = (i < currentParts.length) ? currentParts[i] : 0;
      int tar = (i < targetParts.length) ? targetParts[i] : 0;
      if (cur > tar) return true;
      if (cur < tar) return false;
    }
  } catch (e) {
    return false;
  }

  return false;
}

  Widget _widgetTitle(BuildContext context, OllamaGuiVm vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text("Models", style: textTitle),
            Tooltip(
              message: isVersionGreater(vm.selectedServer?.host.version, "0.5.4") ? "Ollama version <= 0.5.4" : "",
              child: IconButton(
                onPressed: isVersionGreater(vm.selectedServer?.host.version, "0.5.4") ? null : () => onAddModel(context, vm),
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(vm.isExpanded ? Icons.expand_more : Icons.expand_less),
          onPressed: () {
            vm.ToggleExapnded();
          },
        ),
      ],
    );
  }

  Widget _widgetModelList(OllamaGuiVm vm) {
    if (vm.models.isEmpty) return const Center(child: Text("No Models"));

    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior().copyWith(scrollbars: false),
      child: ListView.builder(
        itemCount: vm.models.length,
        itemBuilder: (context, index) {
          final model = vm.models[index];
          return ListTile(
            dense: true,
            leading: ModelWidget.icon(model.name, isActive: false, size: 24),
            title: Text(model.name.toUpperCase()),
            subtitle: Wrap(
              children: [
                Text(model.details.family),
                const Text(" | "),
                Text(model.details.parameterSize),
                const Text(" | "),
                Text(model.details.quantizationLevel),
                const Text(" | "),
                Text(model.formatedSize),
              ],
            ),
            trailing: PopupMenuButton(
              tooltip: "",
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: const Text("Copy"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return OGuiModelCopyView(
                            model.model,
                            onSuccess: (newModel) async {
                              Navigator.pop(context);
                              showNotif(context: context, title: 'Copy Success', content: const Text("Model has been copied"));
                              await OllamaGuiVm.find.getModels(OllamaGuiVm.find.selectedServer);
                            },
                            onError: (err) {
                              Navigator.pop(context);
                              showNotif(context: context, title: 'Copy Failed', content: Text(err.toString()));
                            },
                          );
                        },
                      );
                    },
                  ),
                  PopupMenuItem(
                    enabled: !kIsWeb,
                    child: const Tooltip(message: kIsWeb ? "Unsupported platform" : "", child: Text("Export")),
                    onTap: () async {
                      final exportModel = OllamaGuiModelExport(Core.fileService);

                      await exportModel.export(
                        model: model.model,
                        onStart: () async {
                          WeeShow.loadingOverlay(context, loadingText: "Exporting ...");
                        },
                        onDone: (path) {
                          Navigator.pop(context);
                          showNotif(
                            context: context,
                            title: "Export Success",
                            content: Container(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(model.model),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Process.runSync('open', [path]);
                                },
                                child: const Text("Reveal in Finder"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"),
                              )
                            ],
                          );
                        },
                        onError: (error) {
                          Navigator.pop(context);
                          showNotif(context: context, title: "ERROR", content: Text(error.toString()));
                        },
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("Delete"),
                    onTap: () => onDeleteModel(context, vm, model.model),
                  ),
                ];
              },
            ),
            onTap: () {
              WeeShow.bluredDialog(
                context: context,
                child: OllamaModelDetailsWidget(model: model, ollamax: DM.ollamaModule.ollamax),
              );
            },
          );
        },
      ),
    );
  }

  String formatName(String model, String parameterSize, String quantizationLevel) {
    final modelName = model.contains(":") ? model.split(":").first : model;

    final regex = RegExp(r'^(\d+)(?:\.\d+)?([A-Za-z]+)$');
    final match = regex.firstMatch(parameterSize);

    String paramSizeFormatted = parameterSize;
    if (match != null) {
      final initialValue = match.group(1);
      final size = match.group(2);
      paramSizeFormatted = "$initialValue$size";
    }

    return "$modelName-$paramSizeFormatted-$quantizationLevel";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OllamaGuiVm>(
      builder: (vm) {
        if (vm.loadingModel) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (vm.selectedServerErrorMessage.isNotEmpty) {
          return Center(child: Text(vm.selectedServerErrorMessage));
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (vm.selectedServer != null) _widgetTitle(context, vm),
            Expanded(
              child: _widgetModelList(vm),
            ),
          ],
        );
      },
    );
  }
}
