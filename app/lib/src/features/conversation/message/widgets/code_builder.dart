import 'package:flutter/widgets.dart';
import 'package:flutter_highlight_fork/flutter_highlight_fork.dart' show themeMap, HighlightViewFork;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:ollamb/src/core/modules/preferences/preferences_vm.dart';
export 'package:flutter_highlight_fork/flutter_highlight_fork.dart';

class CodeMarkdownElementBuilder extends MarkdownElementBuilder {
  final Key? key;
  final Map<String, TextStyle>? theme;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final double? borderWidth;
  final double? circleRadius;
  final double? headerHeight;
  final List<Widget> Function(String language, String code, String uniqueId, Color color, Color backgroundColor)? actionsHeader;

  CodeMarkdownElementBuilder({
    this.key,
    this.actionsHeader,
    this.padding,
    this.borderWidth,
    this.circleRadius,
    this.headerHeight,
    this.textStyle,
    this.theme,
  });

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    if (element.attributes['class'] == null && !element.textContent.trim().contains('\n')) {
      // code block no language
      return Container(
        color: preferredStyle!.backgroundColor,
        child: Text(element.textContent.trim(), style: preferredStyle),
      );
    } else {
      String language = 'plaintext';
      final pattern = RegExp(r'^language-(.+)$');
      if (element.attributes['class'] != null && pattern.hasMatch(element.attributes['class']!)) {
        language = pattern.firstMatch(element.attributes['class']!)!.group(1)!;
      }

      return GetBuilder<PreferencesVm>(
        builder: (vm) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: HighlightViewFork(
              key: key,
              element.textContent,
              language: language,
              theme: themeMap[vm.settings.codeSyntaxTheme] ?? themeMap['default']!,
              padding: padding ?? const EdgeInsets.all(16),
              headerHeight: headerHeight ?? 40,
              actionsHeader: actionsHeader == null
                  ? null
                  : (color, backgroundColor) {
                      return actionsHeader!(
                        language,
                        element.textContent.trim(),
                        DateTime.now().millisecondsSinceEpoch.toString(),
                        color,
                        backgroundColor,
                      );
                    },
              borderWidth: borderWidth ?? 0.5,
              circleRadius: circleRadius ?? 0,
              textStyle: textStyle,
            ),
          );
        },
      );
    }
  }
}
