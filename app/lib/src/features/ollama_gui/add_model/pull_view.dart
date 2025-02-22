import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/widgets/model_icon.dart';
import 'package:ollamb/src/widgets/style.dart';

class PullModelVm extends GetxController {
  final List dummy = [
    {
      'name': 'nomic-embed-text',
      'size': '274MB',
      'parameters': '137M',
      'quantization': "F16",
      'label': 'Embeddings',
    },
    {
      'name': 'llama3.2',
      'size': '2GB',
      'parameters': '3B',
      'quantization': "Q4_K_M",
      'label': 'Tools',
    },
    {
      'name': 'gemma2:2b-instruct-q8_0',
      'size': '2.8GB',
      'parameters': '2.61B',
      'quantization': "Q8_0",
      'label': 'Tools',
    },
    {
      'name': 'qwen2.5:3b-instruct-q8_0',
      'size': '3.3GB',
      'parameters': '3.09B',
      'quantization': "Q8_0",
      'label': 'Tools',
    },
    {
      'name': 'mistral',
      'size': '4.1GB',
      'parameters': '7.25B',
      'quantization': "Q4_0",
      'label': 'Tools',
    },
    {
      'name': 'llava',
      'size': '4.7GB',
      'parameters': '7.24B',
      'quantization': "Q4_0",
      'label': 'Vision',
    },
  ];

  bool showCommand = false;
  final TextEditingController modelController = TextEditingController();

  void setShowCommand() {
    showCommand = !showCommand;
    update();
  }
}

class PullModelView extends StatelessWidget {
  const PullModelView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PullModelVm(),
      builder: (vm) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Veniam aliquip consequat nostrud qui minim dolor. Aute velit et dolore mollit. Est in esse consectetur dolor nostrud anim aute elit officia occaecat reprehenderit laborum. Culpa adipisicing aliqua anim duis qui officia incididunt anim in aliquip aliqua dolore."),
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: vm.modelController,
                    onTap: () {
                      print("TAP");
                    },
                    onChanged: (value) {
                      vm.modelController.text = value.replaceFirst("ollama run ", "");
                      vm.update();
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      border: InputBorder.none,
                      hintText: "llama3.3:70b",
                      prefixIconConstraints: BoxConstraints(maxHeight: 30, minWidth: 40),
                      prefixIcon: Icon(Icons.terminal_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(22),
                    backgroundColor: schemeColor(context).surfaceContainerHighest,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Pull"),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(14),
              child: Text("Recommended"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: vm.dummy.length,
                itemBuilder: (context, index) {
                  final data = vm.dummy[index];
                  return ListTile(
                    leading: ModelWidget.icon(data['name'], size: 24),
                    title: Text(data['name']),
                    subtitle: Wrap(
                      children: [
                        Text("${data['parameters']} . "),
                        Text("${data['quantization']} . "),
                        Text("${data['size']}"),
                      ],
                    ),
                    trailing: Text(data['label']),
                    onTap: () {
                      vm.modelController.text = data['name'];
                    },
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
