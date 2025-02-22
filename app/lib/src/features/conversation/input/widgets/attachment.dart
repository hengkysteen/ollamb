import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/features/conversation/input/input_vm.dart';
import 'package:ollamb/src/widgets/style.dart';

class InputMessageAttachmentWidget extends StatelessWidget {
  const InputMessageAttachmentWidget({super.key});

  Widget _image(InputVm vm) {
    return ListTile(
      isThreeLine: true,
      title: const Text("Image"),
      subtitle: const Text("Attachment"),
      leading: SizedBox(height: 45, width: 45, child: Image.memory(gaplessPlayback: true, base64Decode(vm.image!), fit: BoxFit.cover)),
      trailing: IconButton(
        onPressed: () => vm.setImage(null),
        icon: const Icon(Icons.delete),
      ),
    );
  }

  Widget _document(InputVm vm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(vm.document!['name'], maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            "${vm.document!['ext'].toString().toUpperCase()} . ${vm.document!['size']} KB",
            style: const TextStyle(fontSize: 10),
          ),
          leading: const Icon(CupertinoIcons.doc),
          trailing: IconButton(
            onPressed: () {
              vm.setDocument(null);
            },
            icon: const Icon(Icons.delete),
          ),
        ),
        Visibility(
          visible: vm.document!['note'].isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(vm.document!['note'], style: textSmallWarning),
          ),
        ),
      ],
    );
  }

  Widget _card(BuildContext context, Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: 300,
      child: Card(
        color: Theme.of(context).colorScheme.onPrimary,
        elevation: 5,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InputVm>(
      builder: (controller) {
        if (controller.image != null && controller.document == null) {
          return _card(context, _image(controller));
        }
        if (controller.document != null && controller.image == null) {
          return _card(context, _document(controller));
        }
        return const SizedBox();
      },
    );
  }
}
