import 'package:flutter/material.dart';

void showNotif({required BuildContext context, required String title, required Widget content, List<Widget>? actions}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SelectionArea(child: content),
        actions: actions ??
            [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              )
            ],
      );
    },
  );
}
