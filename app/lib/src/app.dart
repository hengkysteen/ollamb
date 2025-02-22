import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/core/modules/preferences/preferences_vm.dart';
import 'package:ollamb/src/features/splash/splash_view.dart';
import 'package:ollamb/src/ui/widgets/macos_menu_bar.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreferencesVm>(
      builder: (_) {
        final Brightness brightness = MediaQuery.platformBrightnessOf(context);
        PreferencesVm.find.listenSystemBrightness(brightness);
        return Column(
          children: [
            if (Core.platform.isMacOS) const MacOsMenuBar(),
            Expanded(
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(PreferencesVm.find.settings.textScaleFactor)),
                child: MaterialApp(
                  title: "Ollamb",
                  debugShowCheckedModeBanner: false,
                  theme: PreferencesVm.find.lightTheme,
                  darkTheme: PreferencesVm.find.darkTheme,
                  themeMode: PreferencesVm.find.settings.themeModeEnum,
                  onGenerateTitle: kIsWeb ? (context) => "Ollamb" : null,
                  home: const SplashView(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
