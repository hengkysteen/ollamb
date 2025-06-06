import 'package:flutter/material.dart';

class PageDialog extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget> titleActions;
  final EdgeInsetsGeometry titlePadding;
  final double contentPadding;
  final bool closeButton;

  const PageDialog({
    super.key,
    required this.child,
    this.title,
    this.titleActions = const [],
    this.titlePadding = const EdgeInsets.all(26),
    this.contentPadding = 16.0,
    this.closeButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null && title!.isNotEmpty)
          Container(
            height: 60,
            padding: const EdgeInsets.only(left: 24, right: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest, width: 0.7)),
            ),
            child: Row(
              children: [
                Text(title!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: Row(children: titleActions)),
                      if (closeButton)
                        Expanded(
                          child: Row(
                            children: [
                              const Spacer(),
                              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                            ],
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 0, left: contentPadding, right: contentPadding, bottom: contentPadding),
            child: child,
          ),
        ),
      ],
    );
  }
}
