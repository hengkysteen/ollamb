import 'package:flutter/material.dart';

const TextStyle textStyle = TextStyle();

TextStyle get textBold => textStyle.copyWith(fontWeight: FontWeight.bold);

TextStyle get textTitle => textStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600);

TextStyle get textHeader => textBold.copyWith(fontSize: 20);

TextStyle get textSmallWarning => textStyle.copyWith(fontSize: 10, color: Colors.red);

Text pageTitle(String text) => Text(text.toUpperCase(), style: textBold.copyWith(fontSize: 18));

ColorScheme schemeColor(BuildContext context) => Theme.of(context).colorScheme;

Color activeColor(BuildContext context, bool active) {
  return active ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodyMedium!.color!;
}
