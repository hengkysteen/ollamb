import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/features/vectorize/data/vectorize_model.dart';
import 'package:ollamb/src/features/vectorize/detail/detail_vm.dart';
import 'package:ollamb/src/features/vectorize/options/vectorize_options_view.dart';
import 'package:ollamb/src/features/vectorize/vectorize_vm.dart';
import 'package:ollamb/src/widgets/dialog.dart';
import 'package:ollamb/src/widgets/page_dialog.dart';

class DocDetailWidget extends StatelessWidget {
  final VectorizeDocument document;
  final VectorizeVm embeddingsVm;
  const DocDetailWidget({super.key, required this.document, required this.embeddingsVm});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DocDetailVm>(
      init: DocDetailVm(embeddingsVm),
      builder: (vm) {
        return PageDialog(
          title: document.title,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: document.vectorize.length,
                        itemBuilder: (context, index) {
                          final vectorize = document.vectorize[index];
                          return ListTile(
                            title: Text(vectorize.text, maxLines: 1, overflow: TextOverflow.ellipsis),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DialogView(child: Text(vectorize.text));
                                },
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              const VerticalDivider(width: 40),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        reverse: true,
                        padding: EdgeInsets.zero,
                        children: vm.searchResult.reversed.toList().map((e) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Query : ", style: TextStyle(color: Theme.of(context).disabledColor)),
                                Text("${e['input']}"),
                                const Divider(),
                                Text(
                                  "Result :  ${(e['similarities'] as List).length}/${vm.chunkRange} ",
                                  style: TextStyle(color: Theme.of(context).disabledColor),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: (e['similarities'] as List).map((e) {
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DialogView(child: Text(e['chunk']));
                                          },
                                        );
                                      },
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Text("${e['chunk']}", maxLines: 1),
                                              const SizedBox(height: 2),
                                              Text(
                                                "Score : ${e['score']}",
                                                style: TextStyle(color: Theme.of(context).disabledColor, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Range : ",
                                style: TextStyle(color: Theme.of(context).disabledColor),
                              ),
                              Text("${vm.chunkRange}"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Treshold : ",
                                style: TextStyle(color: Theme.of(context).disabledColor),
                              ),
                              Text("${vm.threshold}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      minLines: 1,
                      maxLines: 3,
                      controller: vm.searchQueryController,
                      readOnly: vm.isSearch,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) async {
                        if (vm.isSearch) return;
                        await vm.search(document);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        hintText: "Search ...",
                        prefixIcon: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return VectorizeOptionsView(
                                  initRange: vm.chunkRange,
                                  initThreshold: vm.threshold,
                                  onDoneText: "Save",
                                  onDone: (chunkRange, threshold) {
                                    vm.updateOptions(chunkRange: chunkRange, threshold: threshold);
                                  },
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.menu),
                        ),
                        suffixIcon: IconButton(
                          onPressed: vm.isSearch ? null : () async => await vm.search(document),
                          icon: vm.isSearch
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
