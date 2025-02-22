import 'package:flutter/material.dart';

void showNotif({required BuildContext context, required String title, required Widget content, List<Widget>? actions}) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return SelectionArea(
        child: AlertDialog(
          title: Text(title),
          content: content,
          actions: actions ??
              [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok"),
                )
              ],
        ),
      );
    },
  );
}
