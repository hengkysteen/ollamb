import 'package:flutter/material.dart';

class KeyValWidget extends StatelessWidget {
  final String label;
  final Map<String, dynamic>? data;
  const KeyValWidget({super.key, required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 6),
          Column(
            children: data!.entries.toList().asMap().entries.map((entry) {
              int index = entry.key;
              MapEntry e = entry.value;

              Color? backgroundColor = index % 2 == 0 ? Theme.of(context).colorScheme.surfaceContainer : null;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHigh, width: 0.5)),
                ),
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Text("${e.key} : "),
                    Text(
                      e.value.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
