import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/widgets/page_dialog.dart';

class MenusPage extends StatelessWidget {
  final List<MenuItem> items;
  const MenusPage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenusPageVm>(
      init: MenusPageVm(),
      builder: (vm) {
        return PageDialog(
          title: items[vm.currentTab].name,
          contentPadding: 0,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: items[vm.currentTab].page,
                ),
              ),
              VerticalDivider(
                endIndent: 20,
                indent: 20,
                width: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              SizedBox(
                width: 60,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: List.generate(items.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Tooltip(
                          waitDuration: const Duration(milliseconds: 500),
                          message: items[index].name,
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              vm.chageTab(index);
                            },
                            child: items[index].icon(context, vm.currentTab),
                          ),
                        ),
                      );
                    }),
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

class MenuItem {
  final String name;
  final Widget Function(BuildContext context, int index) icon;
  final Widget page;

  const MenuItem({required this.name, required this.icon, required this.page});
}

class MenusPageVm extends GetxController {
  int currentTab = 0;

  void chageTab(int value) {
    currentTab = value;
    update();
  }
}
