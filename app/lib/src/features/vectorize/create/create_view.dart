import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/features/vectorize/create/create_vm.dart';
import 'package:ollamb/src/features/vectorize/data/vectorize_default.dart';
import 'package:ollamb/src/features/vectorize/widgets/model.dart';
import 'package:ollamb/src/features/vectorize/data/vectorize_model.dart';
import 'package:ollamb/src/features/vectorize/vectorize_vm.dart';
import 'package:ollamb/src/features/vectorize/widgets/chunk_input.dart';
import 'package:ollamb/src/widgets/style.dart';
import 'package:wee_kit/wee_kit.dart';

class CreateDocumentVector extends StatelessWidget {
  final VectorizeDocument? data;
  const CreateDocumentVector({super.key, this.data});

  Widget _titleTextField(VectorizeCreateVm vm) {
    return Stack(
      children: [
        TextField(
          onChanged: (_) => vm.update(),
          controller: vm.titleCtrl,
          decoration: const InputDecoration(
            hintText: "Document Title",
            contentPadding: EdgeInsets.only(right: 30, left: 14),
            filled: true,
            border: InputBorder.none,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(right: 4, top: 4),
            child: _moreMenu(vm),
          ),
        ),
      ],
    );
  }

  Widget _moreMenu(VectorizeCreateVm vm) {
    return PopupMenuButton(
      tooltip: "",
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) {
        return [
          PopupMenuItem(onTap: vm.reset, child: const Text("Reset")),
          PopupMenuItem(
            child: const Text("Example"),
            onTap: () {
              vm.titleCtrl.text = defaultVectorize['title'];
              vm.chunks.addAll( defaultVectorize['chunks']);
              vm.update();

            },
          ),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: VectorizeCreateVm(initDocument: data),
      builder: (vm) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _titleTextField(vm),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 14, right: 14, bottom: 14),
                              child: vm.chunks.isEmpty
                                  ? const Center(child: Text("No Data"))
                                  : ListView.builder(
                                      itemCount: vm.chunks.length,
                                      itemBuilder: (context, index) {
                                        final chunk = vm.chunks[index];
                                        return ListTile(
                                          leading: const Icon(CupertinoIcons.doc),
                                          title: Text(chunk, maxLines: 1, overflow: TextOverflow.ellipsis),
                                          trailing: IconButton(
                                            onPressed: () {
                                              vm.removeChunks(chunk);
                                            },
                                            icon: const Icon(Icons.remove),
                                          ),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return ChunkInputView(
                                                  data: chunk,
                                                  onFinnish: (p0) {
                                                    vm.updateChunk(index, p0);
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Text("Model : "),
                        Expanded(child: EmbeddingsModels(vm)),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ],
                ),
              ),
              const VerticalDivider(
                width: 40,
              ),
              SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: const Icon(CupertinoIcons.add),
                      tileColor: schemeColor(context).surfaceContainerHigh,
                      title: const Text("ADD DATA"),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(CupertinoIcons.doc),
                      title: const Text("Manual"),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ChunkInputView(
                              onFinnish: (p0) {
                                vm.chunks.add(p0);
                                vm.update();
                              },
                            );
                          },
                        );
                      },
                    ),
                    const Spacer(),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: vm.chunks.isEmpty || vm.titleCtrl.text.trim().isEmpty
                          ? null
                          : () async {
                              final redy = vm.titleCtrl.text.isNotEmpty && vm.chunks.isNotEmpty;
                              if (!redy) {
                                // controller.titleError = "Title is required";
                                // controller.update();
                                return;
                              }
                              if (vm.model == null) return;
                              WeeShow.loadingOverlay(context);
                              await VectorizeVm.find.createVectorDocument(modelEmbed: vm.model!, chunks: vm.chunks, title: vm.titleCtrl.text);
                              Navigator.pop(context);
                              vm.reset();
                              Navigator.pop(context);
                            },
                      child: const Text("CREATE"),
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
