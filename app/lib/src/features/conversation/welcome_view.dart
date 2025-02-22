import 'package:flutter/material.dart';
import 'package:ollamb/src/widgets/style.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Welcome", style: textHeader),
        const Text("Start a conversation"),
      ],
    );
  }
}
