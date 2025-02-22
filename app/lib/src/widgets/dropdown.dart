import 'package:flutter/material.dart';

class Dropdown<T> extends StatelessWidget {
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final T value;
  final bool isExpanded;
  final bool isDense;
  final bool underline;
  final AlignmentGeometry alignment;
  const Dropdown({
    super.key,
    required this.onChanged,
    required this.items,
    required this.value,
    this.isExpanded = false,
    this.isDense = false,
    this.underline = true,
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
      ),
      child: DropdownButton<T>(
        alignment: alignment,
        padding: EdgeInsets.zero,
        icon: const SizedBox.shrink(),
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
        isExpanded: isExpanded,
        isDense: isDense,
        dropdownColor: Theme.of(context).colorScheme.surface,
        value: value,
        items: items,
        elevation: 1,
        onChanged: onChanged,
        underline: underline ? null : const SizedBox.shrink(),
      ),
    );
  }
}
