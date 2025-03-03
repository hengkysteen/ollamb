import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/dm.dart';
import 'package:ollamb/src/features/prompts/create/create_prompt_view.dart';
import 'package:ollamb/src/features/prompts/data/promtp_repository.dart';
import 'package:ollamb/src/features/prompts/prompts_vm.dart';
import 'package:ollamb/src/features/prompts/widgets/more_button.dart';
import 'package:ollamb/src/widgets/style.dart';
import 'package:wee_kit/wee_kit.dart';

class PromptView extends StatelessWidget {
  final int type;
  final void Function(String data) onSelect;
  const PromptView({super.key, required this.type, required this.onSelect});

  Widget _widgetList(BuildContext context, PromptsVm vm) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text("Prompts", style: textBold.copyWith(fontSize: 18)),
                IconButton(
                  onPressed: () => WeeShow.bluredDialog(context: context, child: CreatePromptView(type: type, onCreated: vm.getPrompt)),
                  icon: const Icon(Icons.add),
                ),
                const Spacer(),
                MoreButton(vm),
              ],
            ),
          ),
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
                  trailing: vm.selectedItem == index
                      ? PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) {
                            final enable = prompt.id != "default_1" && prompt.id != "default_2";
                            return [
                              PopupMenuItem(
                                enabled: enable,
                                child: const Text("Delete"),
                                onTap: () async {
                                  await vm.delete(prompt.id);
                                },
                              ),
                            ];
                          },
                        )
                      : null,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SelectionArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(vm.prompts[vm.selectedItem].name, style: textBold.copyWith(fontSize: 18)),
                    const Divider(),
                    const SizedBox(height: 5),
                    Text(
                      vm.prompts[vm.selectedItem].prompt,
                      style: textStyle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          if (vm.isValid)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PromptsVm>(
      init: PromptsVm(PromtpRepository(DM.promptStorage), type: type),
      builder: (vm) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _widgetList(context, vm),
            const VerticalDivider(width: 0),
            _widgetContent(context, vm),
          ],
        );
      },
    );
  }
}
