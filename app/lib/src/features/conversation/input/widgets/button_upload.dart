import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/features/conversation/input/input_vm.dart';
import 'package:ollamb/src/features/model_options/model_options_vm.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({super.key});

  bool compareWithContextLength(String input, int contextLength) {
    int tokenCount = _estimateTokenCount(input);
    if (tokenCount <= contextLength) {
      return true;
    } else {
      return false;
    }
  }

  int _estimateTokenCount(String input) {
    RegExp tokenPattern = RegExp(r"[\w]+|[^\s\w]");
    Iterable<RegExpMatch> matches = tokenPattern.allMatches(input);
    return matches.length;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
        final position = RelativeRect.fromLTRB(
          details.globalPosition.dx + 10,
          overlay.size.height - 120,
          overlay.size.width - details.globalPosition.dx,
          overlay.size.height - details.globalPosition.dy,
        );
        showMenu(
          context: context,
          position: position,
          constraints: const BoxConstraints(maxWidth: 180, minWidth: 120),
          items: [
            PopupMenuItem(
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Image"),
                  Text("JPG , PNG", style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              onTap: () async {
                final file = await Core.fileService.selectImage();
                if (file == null) return;
                final String base64 = base64Encode(await file.readAsBytes());
                Get.find<InputVm>().setImage(base64);
              },
            ),
            PopupMenuItem(
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Document"),
                  Text("TXT , MD , CSV , JSON", style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              onTap: () async {
                final file = await Core.fileService.selectDocument();
                if (file == null) return;
                final stringDocument = await file.readAsString();
                final size = (await file.length()) / 1024.0;
                final ok = compareWithContextLength(stringDocument, ModelOptionsVm.find.options.numCtx!);
                Get.find<InputVm>().setDocument(
                  {
                    "name": file.name,
                    "content": stringDocument,
                    "size": size.toStringAsFixed(2),
                    "ext": file.name.split(".").last,
                    'note': ok ? "" : "This might be more than ${ModelOptionsVm.find.options.numCtx} tokens. Try increase model context window or shortening the text.",
                  },
                );
              },
            ),
          ],
          menuPadding: EdgeInsets.zero,
        );
      },
      child: SizedBox(
        height: 50,
        width: 50,
        child: Icon(Icons.attach_file, size: 20, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
