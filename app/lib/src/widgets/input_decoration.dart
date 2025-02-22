import 'package:flutter/material.dart';

enum CreateInputDecorationStyle { none, underline, outline }

InputDecoration createInputDecoration({
  required CreateInputDecorationStyle borderStyle,
  Color? fillColor,
  double borderRadius = 20.0,
}) {
  InputDecoration decoration = InputDecoration(
    filled: fillColor != null,
    fillColor: fillColor,
    isDense: true,
    contentPadding: const EdgeInsets.all(16.0),
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
  );

  switch (borderStyle) {
    case CreateInputDecorationStyle.none:
      decoration = decoration.copyWith(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      );
      break;
    case CreateInputDecorationStyle.underline:
      decoration = decoration.copyWith(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
      );
      break;
    case CreateInputDecorationStyle.outline:
      decoration = decoration.copyWith(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      );
      break;
    default:
      break;
  }

  return decoration;
}
