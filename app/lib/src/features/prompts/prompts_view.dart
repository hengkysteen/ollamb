import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/features/prompts/prompts_vm.dart';
import 'package:ollamb/src/widgets/style.dart';

class PromptsCollectionsView extends StatelessWidget {
  /// `user` or `system`
  final int type;
  final void Function(String data) onSelect;
  const PromptsCollectionsView({super.key, required this.type, required this.onSelect});

  ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PromptsVm>(
      init: PromptsVm(type: type),
      builder: (vm) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Flexible(child: Text("Prompt Collections", style: textBold.copyWith(fontSize: 18))),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                  DefaultTabController(
                    length: 3,
                    initialIndex: type,
                    child: TabBar(
                      tabs: const [Tab(text: "ALL"), Tab(text: "SYSTEM"), Tab(text: "USER")],
                      onTap: (value) {
                        vm.filter(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(right: 16),
                      itemCount: vm.data.length,
                      itemBuilder: (context, index) {
                        final prompt = vm.data[index];
                        return ListTile(
                          selected: vm.selectedItem == index,
                          title: Text(prompt['name'], overflow: TextOverflow.ellipsis, maxLines: 1),
                          trailing: vm.selectedItem == index ? const Icon(Icons.arrow_right) : null,
                          onTap: () {
                            vm.setSelectedItem(index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 0),
            Expanded(
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
                            Text(vm.data[vm.selectedItem]['name'], style: textBold.copyWith(fontSize: 18)),
                            const Divider(),
                            const SizedBox(height: 5),
                            Text(
                              vm.data[vm.selectedItem]['prompt'],
                              style: textStyle.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            if (vm.data[vm.selectedItem]['example'] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("Input : ", style: textTitle),
                                  const SizedBox(height: 5),
                                  Text(
                                    vm.data[vm.selectedItem]['example']['input'],
                                    style: textStyle.copyWith(fontSize: 15),
                                  ),
                                  const SizedBox(height: 20),
                                  Text("Output : ", style: textTitle),
                                  Text(
                                    vm.data[vm.selectedItem]['example']['output'],
                                    style: textStyle.copyWith(fontSize: 15),
                                  ),
                                ],
                              )
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
                          onSelect(vm.data[vm.selectedItem]['prompt']);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
