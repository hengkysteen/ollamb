import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/features/conversation/input/input_vm.dart';
import 'package:ollamb/src/features/vectorize/data/vectorize_model.dart';
import 'package:ollamb/src/features/vectorize/create/create_view.dart';
import 'package:ollamb/src/features/vectorize/options/vectorize_options_view.dart';
import 'package:ollamb/src/features/vectorize/vectorize_vm.dart';
import 'package:flutter/material.dart';
import 'package:ollamb/src/widgets/page_dialog.dart';
import 'package:ollamb/src/widgets/show_modal.dart';
import 'package:ollamb/src/widgets/style.dart';
import 'package:wee_kit/wee_kit.dart';
import 'detail/detail_view.dart';

class VectorizeView extends StatelessWidget {
  const VectorizeView({super.key});

  Widget _widgetDocumentListMenus(BuildContext context, VectorizeVm vm, VectorizeDocument document) {
    return SizedBox(
      width: 120,
      child: Row(
        children: [
          InputVm.find.vector?.document.id != document.id
              ? Tooltip(
                  message: "Activate",
                  child: IconButton(
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

                              InputVm.find.setVector(VectorizeAttachment(document: document, range: vm.chunkRange, treshold: vm.threshold));
                              vm.update();
                              Future.delayed(const Duration(milliseconds: 200), () {
                                vm.resetOptions();
                              });
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.play_arrow_outlined),
                  ),
                )
              : Tooltip(
                  message: "Deactivate",
                  child: IconButton(
                    onPressed: () {
                      InputVm.find.setVector(null);
                      vm.update();
                    },
                    icon: const Icon(Icons.stop_outlined),
                  ),
                ),
          Tooltip(
            message: "Edit",
            child: IconButton(
              onPressed: () {
                WeeShow.bluredDialog(
                  context: context,
                  child: CreateDocumentVector(data: document),
                );
              },
              icon: const Icon(Icons.edit_outlined),
            ),
          ),
          Tooltip(
            message: "Delete",
            child: IconButton(
              onPressed: () {
                showNotif(context: context, title: "Delete", content: Text("Are u sure delete ${document.title}?"), actions: [
                  TextButton(
                    onPressed: () async {
                      await vm.deleteDocument(document.id);
                      if (document.id == InputVm.find.vector?.document.id) {
                        InputVm.find.setVector(null);
                      }
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                    child: const Text("Delete"),
                  )
                ]);
              },
              icon: const Icon(Icons.delete_outline),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageDialog(
      title: "Vectorize",
      titleActions: [
        IconButton(
          onPressed: () => WeeShow.bluredDialog(context: context, child: const CreateDocumentVector()),
          icon: const Icon(Icons.add),
        ),
      ],
      child: GetBuilder<VectorizeVm>(
        builder: (vm) {
          if (vm.documents.isEmpty) return const Center(child: Text("No Document"));
          return ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            itemCount: vm.documents.length,
            itemBuilder: (context, index) {
              final document = vm.documents[index];
              return ListTile(
                selected: InputVm.find.vector?.document.id == document.id,
                selectedTileColor: InputVm.find.vector?.document.id == document.id ? schemeColor(context).primary.withAlpha(20) : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 32),
                leading: const Icon(CupertinoIcons.doc_text_search),
                title: Text(document.title),
                subtitle: Text(document.model),
                trailing: _widgetDocumentListMenus(context, vm, document),
                onTap: () {
                  WeeShow.bluredDialog(context: context, child: DocDetailWidget(document: document, embeddingsVm: vm));
                },
              );
            },
          );
        },
      ),
    );
  }
}
