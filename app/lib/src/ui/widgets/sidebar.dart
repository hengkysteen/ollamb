import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/core/dm.dart';
import 'package:ollamb/src/core/modules/conversation/view_models/conversation_vm.dart';
import 'package:ollamb/src/features/ollama_gui/ollama_gui_view.dart';
import 'package:ollamb/src/ui/widgets/desktop_layout/controller.dart';
import 'package:ollamb/src/features/conversation/meta/meta_view.dart';
import 'package:ollamb/src/widgets/circle_button.dart';
import 'package:ollamb/src/widgets/icons.dart';
import 'package:wee_kit/wee_kit.dart';

import 'app_logo.dart';

class DesktopSidebar extends StatelessWidget {
  final DesktopLayoutController controller;

  const DesktopSidebar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          padding: controller.isCollapsed ? const EdgeInsets.only(left: 14) : null,
          alignment: controller.isCollapsed ? Alignment.centerLeft : Alignment.center,
          child: CircleButton(
            height: 40,
            onPressed: () => controller.toggleCollapse(),
            child: Icon(!controller.isCollapsed ? Icons.chevron_left : Icons.chevron_right),
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: controller.isCollapsed ? Alignment.centerLeft : Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 21),
            child: SizedBox(child: AppLogo(isCollapsed: controller.isCollapsed)),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ConversationMetaView(controller.isCollapsed),
        ),
        ListTile(
          contentPadding: const EdgeInsets.only(left: 22),
          selected: controller.tab.index == 0 && controller.tab.data == null,
          leading: const Icon(CupertinoIcons.bubble_left),
          title: controller.isCollapsed ? null : const Text("Conversation"),
          onTap: () {
            if (ConversationVm.find.conversation == null) return;
            if (ConversationVm.find.message != null) return;
            Core.layout.changeTab(0);
            ConversationVm.find.setConversation(null);
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.only(left: 22),
          leading: IconPng(icon: IconsPng.ollama),
          title: controller.isCollapsed ? null : const Text("Ollama"),
          onTap: () async {
            WeeShow.bluredDialog(context: context, child: OllamaGuiView(ollamaModule: DM.ollamaModule));
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.only(left: 22),
          leading: const Icon(CupertinoIcons.settings),
          title: controller.isCollapsed ? null : const Text("Settings"),
          onTap: () async {
            WeeShow.bluredDialog(context: context, child: Core.menusPage);
          },
        ),
      ],
    );
  }
}
