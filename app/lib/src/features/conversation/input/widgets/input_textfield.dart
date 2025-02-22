import 'package:flutter/material.dart';

class InputTextfield extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final Widget prefixIcon;
  final bool enabled;

  const InputTextfield({
    super.key,
    required this.focusNode,
    required this.textEditingController,
    required this.prefixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          TextField(
            enabled: enabled,
            canRequestFocus: true,
            focusNode: focusNode,
            controller: textEditingController,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 10,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(45, 10, 10, 10),
              filled: true,
              hintText: "Message",
              border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(18)),
            ),
          ),
          Positioned(child: prefixIcon)
        ],
      ),
    );
  }
}
