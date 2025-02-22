import 'package:flutter/material.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/ui/widgets/desktop_layout/layout.dart';
import 'package:ollamb/src/ui/widgets/sidebar.dart';

class MainPage extends StatelessWidget {
  final String? initTabName;
  final Map<String, dynamic>? initTabData;
  const MainPage({super.key, this.initTabName, this.initTabData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Core.bodyNode.requestFocus(),
      child: Focus(
        autofocus: true,
        focusNode: Core.bodyNode,
        onKeyEvent: Core.bodyEvent.listen(context),
        child: DesktopLayout(
          controller: Core.layout,
          tabs: const [Core.conversationPage],
          sidebar: () => DesktopSidebar(controller: Core.layout),
        ),
      ),
    );
  }
}
