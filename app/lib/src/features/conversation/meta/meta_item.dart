import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/core/modules/conversation/models/conversation.dart';
import 'package:wee_kit/wee_kit.dart';
import '../../../core/modules/conversation/view_models/conversation_vm.dart';
import 'meta_vm.dart';

class MetaItem extends StatelessWidget {
  final ConversationMeta data;
  final bool isCollapsed;
  const MetaItem(this.data, this.isCollapsed, {super.key});
  Color? _activeColor(BuildContext ctx) {
    return Core.layout.tab.data == data.id ? Theme.of(ctx).colorScheme.primary : null;
  }

  Widget _title(BuildContext context) {
    if (ConversationVm.find.generatingTitleId == data.id) {
      return const Row(
        children: [
          Text("Generating ", style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
          WeeDotLoading(intervalMilliseconds: 300),
        ],
      );
    }
    return Text(
      data.title.isEmpty ? data.id : data.title.truncate(36),
      maxLines: 1,
      style: TextStyle(
        color: _activeColor(context),
        fontSize: 14,
        fontWeight: ConversationVm.find.message?.conversationId == data.id ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _renameTitle(ConversationMeta conversation, MetaVm vm, ConversationVm conversationVm) {
    return TextField(
      onTapOutside: (event) {
        vm.renameTitle = "";
        vm.renameNode.unfocus();
        vm.update();
      },
      focusNode: vm.renameNode,
      controller: TextEditingController(text: conversation.title.isEmpty ? conversation.id : conversation.title),
      decoration: const InputDecoration(
        isDense: true,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        border: InputBorder.none,
      ),
      onSubmitted: (value) {
        vm.setRenameTitle("");
        final updateConversation = ConversationVm.find.conversation;
        if (updateConversation!.title == value) return;
        updateConversation.title = value;
        if (value.isEmpty) return;
        conversationVm.updateConversation(updateConversation);
      },
    );
  }

  void _showCustomMenu(
    BuildContext ctx,
    LongPressStartDetails d,
    ConversationMeta data,
    void Function(String, ConversationMeta) onSelected,
  ) async {
    final globpos = d.globalPosition;
    final off = Offset(globpos.dx, globpos.dy - (kIsWeb ? 0 : 30));
    WeeShow.contextualMenu(context: ctx, position: off, items: [
      PopupMenuItem(child: const Text("Rename"), onTap: () => onSelected("RENAME", data)),
      PopupMenuItem(child: const Text("Delete"), onTap: () => onSelected("DELETE", data)),
    ]);
  }

  Widget? _tileLeading(BuildContext context) {
    if (!isCollapsed) return null;
    return Icon(CupertinoIcons.bubble_left_bubble_right, color: _activeColor(context), size: 22);
  }

  Widget? _tileTitle(BuildContext context, MetaVm vm) {
    if (isCollapsed) return null;
    if (vm.renameTitle == data.id) return _renameTitle(data, vm, ConversationVm.find);
    return _title(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<MetaVm>();
    return GestureDetector(
      onLongPressStart: (details) async {
        await vm.getMetaDetail(data.id);
        if (!context.mounted) return;
        _showCustomMenu(
          context,
          details,
          data,
          (action, meta) async {
            if (action == "RENAME") {
              if (isCollapsed) {
                Core.layout.toggleCollapse();
              }
              vm.setRenameTitle(meta.id);
              Future.delayed(const Duration(milliseconds: 100), () {
                Core.bodyNode.unfocus();
                vm.renameNode.requestFocus();
              });
            }
            if (action == "DELETE") {
              await ConversationVm.find.deleteConversation(data.id);
              ConversationVm.find.setConversation(null);
            }
          },
        );
      },
      child: ListTile(
        selected: Core.layout.tab.data == data.id,
        leading: _tileLeading(context),
        contentPadding: const EdgeInsets.only(left: 22, right: 14),
        title: _tileTitle(context, vm),
        onTap: () async {
          await vm.getMetaDetail(data.id);
        },
      ),
    );
  }
}
