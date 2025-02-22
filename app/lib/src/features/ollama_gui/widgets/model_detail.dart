import 'package:flutter/material.dart';
import 'package:ollamax/ollamax.dart';
import 'package:ollamb/src/widgets/keyval.dart';
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

  // String formatSize(int bytes) {
  //   double mb = bytes / (1000 * 1000); // Menggunakan sistem desimal untuk MB
  //   double gb = bytes / (1000 * 1000 * 1000); // Menggunakan sistem desimal untuk GB
  //   // Jika ukuran lebih dari atau sama dengan 1 GB, tampilkan dalam GB; jika tidak, tampilkan dalam MB
  //   if (gb >= 1) {
  //     return "${gb.toStringAsFixed(2)} GB";
  //   } else {
  //     return "${mb.toStringAsFixed(2)} MB";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center();
                if (!snapshot.hasData) return const SizedBox();
                Map<String, dynamic> modelInformation = snapshot.data;
                return Row(
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
                            Text(
                              model.model.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                const Text("size : "),
                                Text(
                                  model.formatedSize,
                                  style: const TextStyle(),
                                ),
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
                            // SizedBox(height: 30),
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
                                  onTap: modelInformation['modelfile'] == null ? null : () => showDialogModelDetails(context, modelInformation['modelfile']),
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
                                  onTap: modelInformation['template'] == null ? null : () => showDialogModelDetails(context, modelInformation['template']),
                                  child: modelInformation['template'] == null ? const Text("-") : const Text("show", style: TextStyle(color: Colors.blue)),
                                ),
                                const Divider(height: 0)
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                const Text("parameters : "),
                                InkWell(
                                  onTap: modelInformation['parameters'] == null ? null : () => showDialogModelDetails(context, modelInformation['parameters']),
                                  child: modelInformation['parameters'] == null ? const Text("-") : const Text("show", style: TextStyle(color: Colors.blue)),
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
                          // padding: EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          children: [
                            KeyValWidget(label: "MODEL INFO", data: modelInformation['model_info']),
                            KeyValWidget(label: "PROJECTOR INFO", data: modelInformation['projector_info']),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
