import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_model.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_vm.dart';
import 'package:ollamb/src/features/conversation/input/input_vm.dart';
import 'package:ollamb/src/features/model_list/model_list_vm.dart';
import 'package:ollamb/src/widgets/dropdown.dart';
import 'package:ollamb/src/widgets/model_icon.dart';
import 'package:wee_kit/wee_kit.dart';

class ModelListView extends StatelessWidget {
  const ModelListView({super.key});

  Widget modelList(ModelListVm vm) {
    if (vm.modelLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    if (vm.modelLoadingError.isNotEmpty) {
      return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(vm.modelLoadingError)));
    }
    if (vm.models.isEmpty) {
      return const Center(
        child: Text("No Models"),
      );
    }
    return ListView.builder(
      itemCount: vm.models.length,
      itemBuilder: (context, index) {
        final model = vm.models[index];
        final isSelected = model.name == OllamaVm.find.model?.name;
        return ListTile(
          selected: isSelected,
          dense: true,
          leading: ModelWidget.icon(model.name, size: 26, isActive: isSelected),
          title: Text(
            model.name.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
          ),
          subtitle: Row(
            children: [
              Text("${model.quantization} . "),
              Text("${model.paramSize} . "),
              Text(model.size),
            ],
          ),
          onTap: () {
            OllamaVm.find.setModel(model.name);
            InputVm.find.inputFocusNode.requestFocus();
            Navigator.pop(context);
          },
          trailing: !vm.runningModels.any((e) => (e['name'] as String) == model.name)
              ? null
              : Builder(
                  builder: (context) {
                    final rModel = vm.runningModels.firstWhere((e) => e['name'] == model.name);
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Exp ${WeeDateTime.timeLeft(rModel['exp'].toString())}"),
                        Tooltip(
                          message: "Unload",
                          child: IconButton(
                            onPressed: () async {
                              await vm.unload(model.name);
                            },
                            icon: const Icon(Icons.stop),
                          ),
                        )
                      ],
                    );
                  },
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModelListVm>(
      init: ModelListVm(),
      builder: (vm) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<OllamaVm>(
              builder: (ollamaVm) {
                return ListTile(
                  leading: const Text("SERVER"),
                  minLeadingWidth: 34,
                  title: Dropdown(
                    value: ollamaVm.servers.firstWhere((e) => e.host.name == ollamaVm.server.host.name),
                    items: ollamaVm.servers.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text("${e.host.name.toUpperCase()} - ${e.host.url.replaceAll("http://", "")}"),
                      );
                    }).toList(),
                    onChanged: (v) async {
                      await vm.changeServer((v as OllamaServer).host);
                    },
                  ),
                  trailing: Wrap(
                    children: [
                      Tooltip(
                        message: vm.showEmbedModel ? "Hide Unsuported Model" : "Show Unsuported Model",
                        child: IconButton(
                          icon: Icon(vm.showEmbedModel ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            vm.toggleShowEmbedModel();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Tooltip(
                        message: "Running Model",
                        child: Badge(
                          isLabelVisible: vm.showRunningModel,
                          label: Text(vm.runningModels.length.toString()),
                          child: IconButton(
                            onPressed: () async => await vm.getRunningModel(),
                            icon: const Icon(Icons.rocket_launch_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Tooltip(
                        message: "Refresh",
                        child: IconButton(
                          onPressed: () async => await vm.refreshModel(),
                          icon: const Icon(Icons.refresh),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(child: modelList(vm))
          ],
        );
      },
    );
  }
}
