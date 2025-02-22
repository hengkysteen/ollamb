import 'package:flutter/material.dart';
import 'package:ollamb/src/ui/widgets/desktop_layout/controller.dart';

class DesktopLayout extends StatelessWidget {
  final List<Widget> tabs;
  final Widget Function() sidebar;
  final double sidebarWidth;
  final DesktopLayoutController controller;
  final double collapsedWidth;

  const DesktopLayout({
    super.key,
    required this.controller,
    required this.tabs,
    required this.sidebar,
    this.sidebarWidth = 300,
    this.collapsedWidth = 70,
  });

  double getRightPosition(double width) {
    if (width >= 700) return 0.0;
    if (!controller.isCollapsed) return -sidebarWidth;
    return 0.0;
  }

  ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StatefulBuilder(
      builder: (context, state) {
        controller.init(state);
        return SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              SizedBox(
                width: sidebarWidth,
                child: Material(
                  color: colorScheme(context).surfaceContainerLow,
                  child: sidebar(),
                ),
              ),
              AnimatedPositioned(
                left: controller.isCollapsed ? collapsedWidth : sidebarWidth,
                bottom: 0,
                right: getRightPosition(width),
                top: 0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: colorScheme(context).surfaceContainerHighest, width: 1)),
                  ),
                  child: Material(
                    child: tabs[controller.tab.index],
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
