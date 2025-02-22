import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/modules/preferences/preferences_vm.dart';
import 'package:ollamb/src/widgets/icons.dart';
import 'splash_vm.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: SplashVm(context),
        builder: (_) {
          return Center(
            child: GetBuilder<PreferencesVm>(
              builder: (controller) {
                return IconPng(icon: controller.isDark ? IconsPng.logoWhite : IconsPng.logoBlack, size: 60);
              },
            ),
          );
        },
      ),
    );
  }
}
