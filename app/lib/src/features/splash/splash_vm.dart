import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ollamb/src/ui/pages/main_page.dart';
import 'package:wee_kit/wee_kit.dart';

class SplashVm extends GetxController {
  final BuildContext context;
  SplashVm(this.context);

  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (!context.mounted) return;
    return WeeGo.to(context, target: const MainPage(), style: WeeGoStyle.fade, replace: true);
  }

  @override
  void onInit() async {
    await init();
    super.onInit();
  }
}
