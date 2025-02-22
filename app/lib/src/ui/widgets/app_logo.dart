import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/modules/preferences/preferences_vm.dart';
import 'package:ollamb/src/widgets/icons.dart';

class AppLogo extends StatelessWidget {
  final bool isCollapsed;
  const AppLogo({super.key, required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreferencesVm>(
      builder: (theme) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconPng(icon: theme.isDark ? IconsPng.logoWhite : IconsPng.logoBlack, size: 28),
            if (!isCollapsed)
              const Flexible(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        children: [
                          TextSpan(
                            text: " Ol",
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                          ),
                          TextSpan(
                            text: "lamb",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
