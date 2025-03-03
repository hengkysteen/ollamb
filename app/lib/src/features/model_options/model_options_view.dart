import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_vm.dart';
import 'package:ollamb/src/features/model_options/model_options_vm.dart';
import 'package:ollamb/src/features/prompts/widgets/prompts_button.dart';
import 'package:ollamb/src/widgets/dropdown.dart';
import 'package:ollamb/src/widgets/style.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ModelOptionsView extends StatelessWidget {
  const ModelOptionsView({super.key});

  Widget _widgetSliderOptions({
    required BuildContext context,
    required String name,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required label,
    required void Function(double)? onChanged,
    required void Function()? onReset,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 20,
          child: Row(
            children: [
              const SizedBox(width: 22),
              Text("$name : "),
              Text(
                label.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 36,
          child: Row(
            children: [
              Expanded(
                child: Slider(
                  thumbColor: Colors.white,
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  onChanged: onChanged,
                ),
              ),
              SizedBox(
                width: 20,
                height: 20,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: onReset,
                  child: const Icon(CupertinoIcons.restart, size: 18),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModelOptionsVm>(
      dispose: (state) {},
      init: ModelOptionsVm(),
      builder: (vm) {
        final options = vm.options;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ListTile(
                          selected: true,
                          title: const Text("Options"),
                          subtitle: Text.rich(
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            TextSpan(
                              text: "/api/chat options ",
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: InkWell(
                                    onTap: () {
                                      launchUrlString(
                                        "https://github.com/ollama/ollama/blob/main/docs/modelfile.md#parameter",
                                        mode: LaunchMode.externalApplication,
                                      );
                                    },
                                    child: Text(
                                      "parameter",
                                      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              vm.setOptionShow(vm.optionShow == 0 ? 1 : 0);
                            },
                            icon: const Icon(Icons.code),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (vm.optionShow == 0)
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.only(right: 20),
                              shrinkWrap: true,
                              children: [
                                _widgetSliderOptions(
                                  context: context,
                                  name: "Temperature",
                                  value: options.temperature!,
                                  min: 0.1,
                                  max: 2,
                                  divisions: 19,
                                  label: options.temperature!.toStringAsFixed(1),
                                  onChanged: (v) {
                                    options.temperature = double.parse(v.toStringAsFixed(1));
                                    vm.updaetUptions(options);
                                  },
                                  onReset: vm.updateState(() => options.temperature = vm.defaultOptions.temperature),
                                ),
                                _widgetSliderOptions(
                                  context: context,
                                  name: "Seed",
                                  value: options.seed!.toDouble(),
                                  min: 0,
                                  max: 10000,
                                  divisions: 10000,
                                  label: "${options.seed!.toInt()}",
                                  onChanged: (v) {
                                    options.seed = v.toInt();
                                    vm.updaetUptions(options);
                                  },
                                  onReset: vm.updateState(() => options.seed = vm.defaultOptions.seed),
                                ),
                                _widgetSliderOptions(
                                  context: context,
                                  name: "Context",
                                  value: options.numCtx!.toDouble(),
                                  min: 1000,
                                  max: 80000,
                                  label: "${options.numCtx!.toInt()}",
                                  onChanged: (v) {
                                    options.numCtx = v.toInt();
                                    vm.updaetUptions(options);
                                  },
                                  onReset: vm.updateState(() => options.numCtx = vm.defaultOptions.numCtx),
                                ),
                                _widgetSliderOptions(
                                  context: context,
                                  name: "Num Predict",
                                  value: options.numPredict!.toDouble(),
                                  min: -1,
                                  max: 1000,
                                  label: options.numPredict!.toInt(),
                                  onChanged: (v) {
                                    options.numPredict = v.toInt();

                                    vm.updaetUptions(options);
                                  },
                                  onReset: vm.updateState(() => options.numPredict = vm.defaultOptions.numPredict),
                                ),
                                _widgetSliderOptions(
                                  context: context,
                                  name: "Repeat Penalty",
                                  value: options.repeatPenalty!,
                                  min: 0.0,
                                  max: 5.0,
                                  divisions: 50,
                                  label: options.repeatPenalty!.toStringAsFixed(1),
                                  onChanged: (v) {
                                    options.repeatPenalty = v;
                                    vm.updaetUptions(options);
                                  },
                                  onReset: vm.updateState(() => options.repeatPenalty = vm.defaultOptions.repeatPenalty),
                                ),
                                _widgetSliderOptions(
                                  context: context,
                                  name: "Top K",
                                  value: options.topK!.toDouble(),
                                  min: 0,
                                  max: 100,
                                  divisions: 10,
                                  label: options.topK!.toString(),
                                  onChanged: (v) {
                                    options.topK = v.toInt();

                                    vm.updaetUptions(options);
                                  },
                                  onReset: vm.updateState(() => options.topK = vm.defaultOptions.topK),
                                ),
                                _widgetSliderOptions(
                                  context: context,
                                  name: "Top P",
                                  value: options.topP!,
                                  min: 0,
                                  max: 2.0,
                                  divisions: 20,
                                  label: options.topP!.toStringAsFixed(1),
                                  onChanged: (v) {
                                    options.topP = v;
                                    vm.updaetUptions(options);
                                  },
                                  onReset: vm.updateState(() => options.topP = vm.defaultOptions.topP),
                                ),
                              ],
                            ),
                          ),
                        if (vm.optionShow == 1)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                              child: TextField(
                                controller: vm.jsonOptionController,
                                maxLines: null,
                                expands: true,
                                style: TextStyle(color: vm.jsonOptionsError.isNotEmpty ? Colors.red : null),
                                onChanged: (value) {
                                  vm.setJsonOptions(value);
                                },
                                decoration: const InputDecoration(
                                  filled: true,
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(Radius.circular(14)),
                                  ),
                                  hoverColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        Visibility(
                          visible: vm.optionShow == 1 && vm.jsonOptionsError.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Text(vm.jsonOptionsError, style: textSmallWarning),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: ModelOptionsVm.find.resetDefaut,
                          child: const Text("Reset"),
                        ),
                        const Spacer(),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: vm.isValidToActivated
                              ? null
                              : () {
                                  Navigator.of(context).pop();
                                  ModelOptionsVm.find.toggleActivate();
                                },
                          child: Text(ModelOptionsVm.find.isActivate == false ? "Activate" : "Deactivate"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      OllamaVm.find.model!.name.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Stack(
                        children: [
                          TextField(
                            controller: vm.keepAliveValue,
                            onChanged: (value) {
                              vm.setKeepAlive(value);
                            },
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*$')),
                            ],
                            decoration: InputDecoration(
                              label: const Text("KEEP ALIVE"),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(14)),
                              ),
                              hoverColor: Colors.transparent,
                              filled: true,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Dropdown(
                                  underline: false,
                                  value: vm.keepAliveDuration,
                                  items: ["s", "m", "h"].map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase()))).toList(),
                                  onChanged: (v) {
                                    vm.keepAliveDuration = v!;
                                    vm.update();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Stack(
                        children: [
                          TextField(
                            controller: vm.systemPromptController,
                            expands: true,
                            maxLines: null,
                            onChanged: (value) {
                              vm.setSystemPrompt(value);
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(16),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(14)),
                              ),
                              filled: true,
                              hoverColor: Colors.transparent,
                              hintText: "You are a helpful assistant",
                              label: Text("SYSTEM PROMPT"),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              alignLabelWithHint: true,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: const SystemPromptsButton(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
