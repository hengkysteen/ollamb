import 'package:flutter/material.dart';
import 'package:ollamb/src/widgets/icons.dart';

class ModelStyle {
  final Color? color;
  final String icon;

  ModelStyle(this.color, this.icon);

  static ModelStyle fromModel(String model) {
    final name = _extractModelName(model);

    switch (name.toLowerCase()) {
      case 'qwen':
        return ModelStyle(Colors.purple, IconsPng.qwen2);
      case 'llama':
        return ModelStyle(Colors.blue, IconsPng.llama);
      case 'llava':
        return ModelStyle(Colors.deepOrange, IconsPng.llava);
      case 'mistral':
        return ModelStyle(Colors.deepOrange, IconsPng.mistral);
      case 'falcon':
        return ModelStyle(Colors.deepPurple, IconsPng.ollama);
      case 'granite':
        return ModelStyle(Colors.green, IconsPng.granite);
      case 'deepseek':
        return ModelStyle(Colors.blue, IconsPng.deepseek);
      case 'phi':
        return ModelStyle(null, IconsPng.microsoft);
      case 'gemma':
        return ModelStyle(null, IconsPng.gemma);
      default:
        return ModelStyle(null, IconsPng.ollama);
    }
  }

  static String _extractModelName(String input) {
    RegExp regex = RegExp(r'^[a-zA-Z]+');
    Match? match = regex.firstMatch(input.trim());
    return match?.group(0) ?? '';
  }
}
