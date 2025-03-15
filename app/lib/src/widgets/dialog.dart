import 'package:flutter/material.dart';

class DialogView extends StatelessWidget {
  final Widget child;
  final double? height;
  const DialogView({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 600,
        height: height,
        child: Material(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(width: 0.7, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.4)),
          ),
          borderOnForeground: true,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: SingleChildScrollView(child: SelectionArea(child: child)),
          ),
        ),
      ),
    );
  }
}
