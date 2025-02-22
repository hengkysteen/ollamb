import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/modules/preferences/preferences_vm.dart';
import 'package:ollamb/src/widgets/model_style.dart';

class ModelWidget {
  static Widget icon(
    String name, {
    double size = 12,
    double padding = 2,
    Color? borderColor,
    Color? color,
    double borderWidth = 0.8,
    bool isActive = false,
  }) {
    return Builder(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              width: borderWidth,
              color: !isActive ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.primary,
            ),
          ),
          padding: EdgeInsets.all(padding),
          child: GetBuilder<PreferencesVm>(
            builder: (controller) {
              return ClipOval(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    !isActive
                        ? controller.isDark
                            ? Colors.white
                            : Colors.grey
                        : Theme.of(context).colorScheme.primary,
                    // BlendMode.srcIn,
                    BlendMode.srcATop,
                  ),
                  child: Image.asset(ModelStyle.fromModel(name).icon, height: size, width: size),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static Widget name(String name) {
    return Text(
      name,
      maxLines: 1,
      style: const TextStyle(fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
    );
  }
}
