import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double height;

  const CircleButton({super.key, required this.child, required this.onPressed, this.padding, this.height = 50, this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.padded,
      height: height,
      minWidth: height,
      padding: padding,
      elevation: 0,
      splashColor: Colors.transparent,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      color: color ?? colorScheme.surfaceContainerHigh,
      hoverColor: color?.withOpacity(0.4),
      shape: const CircleBorder(),
      onPressed: onPressed,
      child: child,
    );
  }
}
