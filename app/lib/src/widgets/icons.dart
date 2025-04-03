import 'package:flutter/material.dart';

class IconsPng {
  static String qwen2 = "assets/models/qwen.png";
  static String ollama = "assets/models/ollama.png";
  static String llama = "assets/models/llama.png";
  static String llava = "assets/models/llava.png";
  static String mistral = "assets/models/mistral.png";
  static String granite = "assets/models/granite.png";
  static String deepseek = "assets/models/deep-seek.png";
  static String microsoft = "assets/models/microsoft.png";
  static String gemma = "assets/models/gemma.png";
  static String logoBlack = "assets/logo/logo-black.png";
  static String logoWhite = "assets/logo/logo-white.png";
}

class IconPng extends StatelessWidget {
  final double size;
  final String icon;
  final Color? color;

  const IconPng({super.key, required this.icon, this.size = 25, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: ClipOval(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            color == null ? Theme.of(context).textTheme.bodyMedium!.color! : color!,
            BlendMode.srcIn,
          ),
          child: Image.asset(icon),
        ),
      ),
    );
  }
}
