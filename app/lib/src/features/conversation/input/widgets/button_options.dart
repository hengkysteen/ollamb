import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/features/model_options/model_options_vm.dart';
import 'package:ollamb/src/features/model_options/model_options_view.dart';
import 'package:wee_kit/wee_kit.dart';

class OptionsButton extends StatelessWidget {
  final String? model;

  const OptionsButton({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModelOptionsVm>(
      init: ModelOptionsVm(),
      builder: (vm) {
        return Tooltip(
          message: "Model Options",
          preferBelow: false,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(10),
            onPressed: model == null ? null : () => onTap(context),
            child: Badge(
              isLabelVisible: vm.isActivate ? true : false,
              child: Icon(
                CupertinoIcons.slider_horizontal_3,
                size: 22,
                color: model == null ? null : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
        );
      },
    );
  }

  void onTap(BuildContext context) {
    WeeShow.bluredDialog(context: context, child: const ModelOptionsView());
  }
}
