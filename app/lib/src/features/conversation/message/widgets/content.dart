import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:ollamb/src/core/modules/preferences/preferences_vm.dart';
import 'package:ollamb/src/features/conversation/message/message_vm.dart';
import 'package:ollamb/src/features/conversation/message/widgets/code_builder.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MessageContent extends StatelessWidget {
  final String data;
  const MessageContent({required this.data, super.key});

  Widget Function(Uri, String?, String?)? imageBUilder(BuildContext context) {
    return (uri, title, alt) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceDim,
        height: 200,
        width: 200,
        child: Image.network(
          uri.toString(),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey));
          },
        ),
      );
    };
  }

  md.ExtensionSet extensionSet() {
    return md.ExtensionSet(
      [
        ...md.ExtensionSet.gitHubFlavored.blockSyntaxes,
      ],
      [
        ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
        md.EmojiSyntax(),
      ],
    );
  }

  Widget copyCode(String code, String id, Color color) {
    return GetBuilder<MessageVm>(
      builder: (vm) {
        return Tooltip(
          message: "Copy Code",
          child: IconButton(
            iconSize: 14,
            onPressed: () async {
              await vm.copyCodeSytax(code, id);
            },
            icon: Icon(
              vm.isCodeSyntaxCopied && vm.codeSyntaxId == id ? Icons.done : Icons.copy_outlined,
              color: color,
            ),
          ),
        );
      },
    );
  }

  Map<String, MarkdownElementBuilder> elementBuilders() {
    return {
      'code': CodeMarkdownElementBuilder(
        textStyle: const TextStyle(fontSize: 13),
        circleRadius: 16,
        actionsHeader: (_, code, id, color, __) => [copyCode(code, id, color)],
      )
    };
  }

  void Function(String, String?, String)? onTapLink() {
    return (text, href, title) async {
      if (href != null) {
        await launchUrlString(href, mode: LaunchMode.externalApplication);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreferencesVm>(
      builder: (_) {
        if (PreferencesVm.find.settings.responseFormat == "Plaintext") return Text(data);
        return MarkdownBody(
          data: data,
          onSelectionChanged: null,
          styleSheet: MarkdownStyleSheet(
            codeblockDecoration: const BoxDecoration(color: Colors.transparent),
            code: TextStyle(fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize, fontFamily: 'Courier'),
          ),
          extensionSet: extensionSet(),
          imageBuilder: imageBUilder(context),
          onTapLink: onTapLink(),
          builders: elementBuilders(),
        );
      },
    );
  }
}
