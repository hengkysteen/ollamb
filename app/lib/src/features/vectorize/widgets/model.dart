import 'package:flutter/material.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_vm.dart';
import 'package:ollamb/src/features/vectorize/create/create_vm.dart';
import 'package:ollamb/src/widgets/dropdown.dart';

class EmbeddingsModels extends StatelessWidget {
  final VectorizeCreateVm vm;
  const EmbeddingsModels(this.vm, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dropdown<String?>(
      // underline: false,
      isExpanded: true,
      isDense: true,
      value: vm.model,
      items: OllamaVm.find.server.models
          .map((e) => DropdownMenuItem(
              value: e.name,
              child: Text(
                e.name.toUpperCase(),
                maxLines: 1,
              )))
          .toList(),
      onChanged: (v) {
        vm.model = v!;
        vm.update();
      },
    );
  }
}
