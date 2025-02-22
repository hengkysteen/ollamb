import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenusPage extends StatelessWidget {
  final List<MenuItem> items;
  const MenusPage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenusPageVm>(
      init: MenusPageVm(),
      builder: (vm) {
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: items[vm.currentTab].page),
                  SizedBox(
                    width: 70,
                    child: Card(
                      elevation: 1,
                      shape: const RoundedRectangleBorder(),
                      margin: EdgeInsets.zero,
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
                  ),
                ],
              ),
            )
          ],
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
