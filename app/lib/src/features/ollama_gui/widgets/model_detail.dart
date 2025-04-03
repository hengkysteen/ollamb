import 'package:flutter/material.dart';
import 'package:ollamax/ollamax.dart';
import 'package:ollamb/src/features/ollama_gui/widgets/keyval.dart';
import 'package:ollamb/src/widgets/page_dialog.dart';
import 'package:wee_kit/wee_kit.dart';

class OllamaModelDetailsWidget extends StatelessWidget {
  final OllamaxModel model;
  final Ollamax ollamax;
  const OllamaModelDetailsWidget({super.key, required this.model, required this.ollamax});

  Future getData() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return await ollamax.showModel(model.model);
  }

  void showDialogModelDetails(BuildContext context, String? text) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: text == null ? const Text("-") : SingleChildScrollView(child: SelectableText(text)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center();
        if (!snapshot.hasData) return const SizedBox();

        Map<String, dynamic> modelInformation = snapshot.data;

        return PageDialog(
          title: model.model.toUpperCase(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          const Text("size : "),
                          Text(model.formatedSize, style: const TextStyle()),
                          const Divider(height: 0),
                        ],
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          const Text("modified_at : "),
                          Text(
                            DateFormat('yMMMd').format(DateTime.parse(model.modifiedAt)),
                            style: const TextStyle(),
                          ),
                          const Divider(height: 0),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: (modelInformation['details'] as Map)
                            .entries
                            .map((e) {
                              return Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.end,
                                runAlignment: WrapAlignment.start,
                                verticalDirection: VerticalDirection.down,
                                children: [
                                  Text("${e.key} : "),
                                  Text(
                                    e.value.isEmpty ? "-" : e.value.toString(),
                                    style: const TextStyle(),
                                  ),
                                  const Divider(height: 0)
                                ],
                              );
                            })
                            .toList()
                            .reversed
                            .toList(),
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          const Text("digest : "),
                          Text(
                            model.digest.isEmpty ? "-" : model.digest.toString(),
                            style: const TextStyle(),
                          ),
                          const Divider(height: 0),
                        ],
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          const Text("modelfile : "),
                          InkWell(
                            onTap: modelInformation['modelfile'] == null
                                ? null
                                : () => showDialogModelDetails(
                                      context,
                                      modelInformation['modelfile'],
                                    ),
                            child: modelInformation['modelfile'] == null
                                ? const Text("-")
                                : const Text(
                                    "show",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                          ),
                          const Divider(height: 0)
                        ],
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          const Text("template : "),
                          InkWell(
                            onTap: modelInformation['template'] == null
                                ? null
                                : () => showDialogModelDetails(
                                      context,
                                      modelInformation['template'],
                                    ),
                            child: modelInformation['template'] == null
                                ? const Text("-")
                                : const Text(
                                    "show",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                          ),
                          const Divider(height: 0)
                        ],
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          const Text("parameters : "),
                          InkWell(
                            onTap: modelInformation['parameters'] == null
                                ? null
                                : () => showDialogModelDetails(
                                      context,
                                      modelInformation['parameters'],
                                    ),
                            child: modelInformation['parameters'] == null
                                ? const Text("-")
                                : const Text(
                                    "show",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                          ),
                          const Divider(height: 0)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 0,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      KeyValWidget(
                        label: "MODEL INFO",
                        data: modelInformation['model_info'],
                      ),
                      KeyValWidget(
                        label: "PROJECTOR INFO",
                        data: modelInformation['projector_info'],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
