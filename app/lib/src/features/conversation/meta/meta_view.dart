import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/features/conversation/meta/meta_vm.dart';
import 'package:ollamb/src/features/conversation/meta/meta_item.dart';
import '../../../core/modules/conversation/view_models/conversation_vm.dart';

class ConversationMetaView extends StatelessWidget {
  final bool isCollapsed;
  const ConversationMetaView(this.isCollapsed, {super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConversationVm>(
      builder: (_) {
        if (ConversationVm.find.conversationsMeta.isEmpty) {
          return Center(
            child: Text(
              Core.layout.isCollapsed ? "" : "No Conversation",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }
        return GetBuilder<MetaVm>(
          init: MetaVm(),
          builder: (vm) {
            return ScrollConfiguration(
              behavior: const MaterialScrollBehavior().copyWith(scrollbars: false),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: ConversationVm.find.conversationsMeta.length,
                itemBuilder: (context, index) {
                  final conversation = ConversationVm.find.conversationsMeta.reversed.toList()[index];
                  return MetaItem(key: ValueKey(conversation.id), conversation, isCollapsed);
                },
              ),
            );
          },
        );
      },
    );
  }
}
