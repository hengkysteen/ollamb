import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ollamb/src/core/modules/conversation/view_models/conversation_vm.dart';
import 'package:ollamb/src/features/conversation/message/widgets/content.dart';
import 'package:ollamb/src/features/conversation/message/widgets/file_preview.dart';
import 'package:ollamb/src/features/conversation/message/widgets/footer.dart';
import 'package:ollamb/src/widgets/model_icon.dart';
import 'package:ollamb/src/widgets/style.dart';
import 'package:wee_kit/wee_kit.dart';
import '../../../core/modules/conversation/models/message.dart';

class MessageView extends StatelessWidget {
  final Message message;
  const MessageView(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: ConversationVm.find.lastMessage.id == message.id ? 30 : 10),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
        color: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      child: Column(
        children: [
          MessageUser(message),
          const Divider(height: 30),
          MessageModel(message),
          message.isDone ? MessageFooter(message: message) : const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class MessageUser extends StatelessWidget {
  final Message message;
  const MessageUser(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    Uint8List? image;
    if (message.prompt.image != null) {
      image ??= base64Decode(message.prompt.image!);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(CupertinoIcons.person_crop_circle, size: 16, color: schemeColor(context).primary),
            const SizedBox(width: 5),
            const Text("USER"),
          ],
        ),
        if (image != null) ImagePreview(image: image),
        if (message.prompt.document != null) DocumentPreview(fileName: message.prompt.document?['name']),
        const SizedBox(height: 8),
        Text(message.prompt.text),
      ],
    );
  }
}

class MessageModel extends StatelessWidget {
  final Message message;
  const MessageModel(this.message, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ModelWidget.icon(message.model, isActive: true, size: 10),
            const SizedBox(width: 5),
            Text(message.model.toUpperCase()),
          ],
        ),
        const SizedBox(height: 8),
        message.content.isEmpty ? const WeeDotLoading(dotLength: 4) : MessageContent(data: message.content),
      ],
    );
  }
}
