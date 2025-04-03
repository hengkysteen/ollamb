import 'package:flutter/material.dart';

class ShortcutsInfo extends StatelessWidget {
  const ShortcutsInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      preferBelow: false,
      message: """
Body Focus : 
LEFT SHIFT + <- or -> = Toggle Sidebar
LEFT SHIFT + S = Show Menus
LEFT SHIFT + D = Show Models
LEFT SHIFT + A = Show Model Options
LEFT SHIFT + F = Show Prompts
LEFT SHIFT + W = Show Ollama
LEFT SHIFT + V = Show Vectorize
LEFT SHIFT + C = New Conversation

Input Message Focus:
LEFT SHIFT + ENTER = Send or Stop Message""",
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          Icons.keyboard_alt_outlined,
          size: 12,
          color: Theme.of(context).disabledColor,
        ),
      ),
    );
  }
}
