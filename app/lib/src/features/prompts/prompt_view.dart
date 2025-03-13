import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/dm.dart';
import 'package:ollamb/src/features/prompts/data/promtp_repository.dart';
import 'package:ollamb/src/features/prompts/prompts_vm.dart';
import 'package:ollamb/src/features/prompts/widgets/more_button.dart';
import 'package:ollamb/src/widgets/page_dialog.dart';
import 'package:ollamb/src/widgets/show_modal.dart';
import 'package:ollamb/src/widgets/style.dart';

class PromptView extends StatelessWidget {
  final int type;
  final void Function(String data) onSelect;
  const PromptView({super.key, required this.type, required this.onSelect});

  Widget _widgetList(BuildContext context, PromptsVm vm) {
    return Expanded(
      child: Column(
        children: [
          DefaultTabController(
            length: 3,
            initialIndex: type,
            child: TabBar(tabs: const [Tab(text: "ALL"), Tab(text: "SYSTEM"), Tab(text: "USER")], onTap: (value) => vm.filter(value)),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: vm.prompts.length,
              itemBuilder: (context, index) {
                final prompt = vm.prompts[index];
                return ListTile(
                  selected: vm.selectedItem == index,
                  title: Text(prompt.name, overflow: TextOverflow.ellipsis, maxLines: 1),
                  onLongPress: prompt.id != "default_1" && prompt.id != "default_2"
                      ? null
                      : () {
                          showNotif(context: context, title: "Delete", content: SizedBox(), actions: [
                            IconButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await vm.delete(prompt.id);
                              },
                              icon: Text("Delete"),
                            )
                          ]);
                        },
                  // trailing: vm.selectedItem == index
                  //     ? PopupMenuButton(
                  //         icon: const Icon(Icons.more_vert),
                  //         itemBuilder: (context) {
                  //           final enable = prompt.id != "default_1" && prompt.id != "default_2";
                  //           return [
                  //             PopupMenuItem(
                  //               enabled: enable,
                  //               child: const Text("Delete"),1
                  //               onTap: () async {
                  //                 await vm.delete(prompt.id);
                  //               },
                  //             ),
                  //           ];
                  //         },
                  //       )
                  //     : null,
                  onTap: () {
                    vm.setSelectedItem(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetContent(BuildContext context, PromptsVm vm) {
    if (vm.prompts.isEmpty) {
      return const Center(child: Text("No prompts"));
    }
    return Expanded(
      child: Container(
        // padding: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: schemeColor(context).surfaceContainerHigh, borderRadius: BorderRadius.circular(16)),
                child: SelectionArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(vm.prompts[vm.selectedItem].name, style: textBold.copyWith(fontSize: 18)),
                          const SizedBox(height: 5),
                          Text(vm.prompts[vm.selectedItem].prompt, style: textStyle.copyWith(fontSize: 16)),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (vm.isValid)
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: schemeColor(context).primary.withAlpha(50),
                    foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text("Select"),
                  onPressed: () {
                    Navigator.pop(context);
                    onSelect(vm.prompts[vm.selectedItem].prompt);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PromptsVm>(
      init: PromptsVm(PromtpRepository(DM.promptStorage), type: type),
      builder: (vm) {
        return PageDialog(
          title: "Prompt Collections",
          titleActions: [
            MoreButton(vm),
          ],
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _widgetList(context, vm),
                const VerticalDivider(width: 30),
                _widgetContent(context, vm),
              ],
            ),
          ),
        );
      },
    );
  }
}
