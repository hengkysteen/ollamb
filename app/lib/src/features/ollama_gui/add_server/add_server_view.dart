import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_model.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_repository.dart';
import 'package:ollamb/src/features/ollama_gui/add_server/add_server_vm.dart';

class AddServerView extends StatelessWidget {
  final OllamaRepository ollamaRepository;

  final void Function(OllamaHost host) onData;

  const AddServerView({super.key, required this.ollamaRepository, required this.onData});

  Widget field(TextEditingController controller, String error, String label, String hint) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              label: Text(label),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: hint,
            ),
          ),
          Container(
            height: 20,
            alignment: Alignment.bottomLeft,
            child: Visibility(
              visible: error.isNotEmpty,
              child: Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OllamGuiAddServerVm>(
      init: OllamGuiAddServerVm(ollamaRepository),
      builder: (vm) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(
                  width: 0.3,
                  color: Theme.of(context).textTheme.bodyLarge!.color!,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(blurRadius: 1, spreadRadius: 0.3, color: Colors.black.withOpacity(0.1))],
              ),
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  field(vm.name, vm.nameError, "Label", "my_laptop"),
                  field(vm.url, vm.urlError, "URL", "http://127.0.0.1:11434"),
                  if (vm.serverError.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        vm.serverError,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.only(top: 2),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextButton(
                      onPressed: () async {
                        await vm.submit(
                          (server) {
                            onData(server);
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: const Text("Add Server"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
