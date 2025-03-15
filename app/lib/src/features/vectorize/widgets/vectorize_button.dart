import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ollamb/src/features/conversation/input/input_vm.dart';
import 'package:ollamb/src/features/vectorize/vectorize_view.dart';
import 'package:wee_kit/wee_kit.dart';

class VectorizeButton extends StatelessWidget {
  final InputVm inputVm;
  const VectorizeButton(this.inputVm, {super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      preferBelow: false,
      message: inputVm.vector == null ? "Vectorize" : "Active : ${inputVm.vector!.document.title}",
      child: InkWell(
        onTapDown: (details) {
          WeeShow.bluredDialog(context: context, child: const VectorizeView());
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Badge(
            backgroundColor: Colors.red,
            padding: EdgeInsets.zero,
            isLabelVisible: inputVm.vector != null ? true : false,
            child: const Icon(
              CupertinoIcons.doc_text_search,
              size: 17,
            ),
          ),
        ),
      ),
    );
  }
}
