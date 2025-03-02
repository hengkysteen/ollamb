import 'package:flutter/material.dart';
import 'package:ollamb/src/features/prompts/prompts_vm.dart';
import 'package:ollamb/src/widgets/show_modal.dart';
import 'package:wee_kit/wee_kit.dart';

class MoreButton extends StatelessWidget {
  final PromptsVm _promptsVm;
  const MoreButton(this._promptsVm, {super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: "",
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: const Text("Add From Resource"),
            onTap: () async {
              WeeShow.loadingOverlay(context, loadingText: "Fetch from github ...");
              await _promptsVm.install(
                onSuccess: () {
                  Navigator.pop(context);
                  showNotif(context: context, title: "Success", content: const Text("Prompts added successfully"));
                },
                onError: (err) {
                  Navigator.pop(context);
                  showNotif(context: context, title: "Error", content: Text(err));
                },
              );
            },
          ),
          PopupMenuItem(
            child: const Text("Delete All"),
            onTap: () async {
              await _promptsVm.deleteAll();
            },
          ),
        ];
      },
    );
  }
}
