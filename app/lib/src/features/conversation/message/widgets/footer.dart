import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ollamb/src/core/modules/conversation/models/message.dart';
import 'package:ollamb/src/core/modules/conversation/view_models/conversation_vm.dart';
import 'package:ollamb/src/features/conversation/message/message_vm.dart';

class MessageFooter extends StatelessWidget {
  final Message message;
  const MessageFooter({super.key, required this.message});
  final waitDuration = const Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    final vm = MessageVm.find;
    return Container(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Tooltip(
            waitDuration: waitDuration,
            preferBelow: true,
            message: vm.getResponseInfo(message),
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.info_outline, size: 15),
            ),
          ),
          Tooltip(
            waitDuration: waitDuration,
            message: "Delete",
            child: IconButton(
              onPressed: () => vm.deleteMessage(message),
              icon: const Icon(Icons.delete_outline, size: 15),
            ),
          ),
          if (ConversationVm.find.lastMessage.id == message.id)
            Tooltip(
              waitDuration: waitDuration,
              message: "Generate",
              child: IconButton(
                onPressed: () => vm.resendLastMessage(message),
                icon: const Icon(CupertinoIcons.repeat, size: 15),
              ),
            ),
          MessageVm.find.speachId != message.id
              ? Tooltip(
                  waitDuration: waitDuration,
                  message: "Play",
                  child: IconButton(
                    onPressed: MessageVm.find.isSpeachPlayed ? null : () async => await vm.playSpeach(message),
                    icon: const Icon(CupertinoIcons.speaker, size: 16),
                  ),
                )
              : Tooltip(
                  waitDuration: waitDuration,
                  message: "Stop",
                  child: IconButton(
                    onPressed: MessageVm.find.stopSpeach,
                    icon: const Icon(CupertinoIcons.stop, size: 16, color: Colors.red),
                  ),
                ),
          if (MessageVm.find.copyId != message.id)
            Tooltip(
              waitDuration: waitDuration,
              message: "Copy",
              child: IconButton(
                onPressed: () => vm.copyMessage(message),
                icon: const Icon(Icons.copy_outlined, size: 15),
              ),
            ),
          if (MessageVm.find.copyId == message.id)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.check, size: 15),
            ),
        ],
      ),
    );
  }
}
