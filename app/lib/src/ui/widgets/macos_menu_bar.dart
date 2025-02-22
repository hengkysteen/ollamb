import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:ollamb/src/core/modules/preferences/preferences_vm.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MacOsMenuBar extends StatelessWidget {
  const MacOsMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreferencesVm>(
      builder: (controller) {
        final Brightness brightness = MediaQuery.platformBrightnessOf(context);
        controller.listenSystemBrightness(brightness);
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            alignment: Alignment.centerLeft,
            height: 30,
            decoration: BoxDecoration(
              color: ColorScheme.fromSeed(
                seedColor: controller.settings.themeColor,
                brightness: controller.isDark ? Brightness.dark : Brightness.light,
              ).surfaceContainerLow,
              border: Border(
                bottom: BorderSide(
                  color: ColorScheme.fromSeed(
                    seedColor: controller.settings.themeColor,
                    brightness: controller.isDark ? Brightness.dark : Brightness.light,
                  ).surfaceContainerHighest,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text(
                    "Contact",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  onPressed: () async {
                    const target = "mailto:hengkysteen@gmail.com?subject=Ollamb Macos&body=Hello";
                    await launchUrlString(target, mode: LaunchMode.platformDefault);
                  },
                ),
                const SizedBox(width: 10),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text(
                    "Github",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  onPressed: () async {
                    const target = "https://github.com/hengkysteen/ollamb";
                    await launchUrlString(target, mode: LaunchMode.externalApplication);
                  },
                ),
                const SizedBox(width: 10),
                const Text(
                  "v0.0.1",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
