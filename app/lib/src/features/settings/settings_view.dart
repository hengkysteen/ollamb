import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/configs/path.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/core/modules/preferences/preferences_vm.dart';
import 'package:ollamb/src/widgets/dropdown.dart';
import 'package:ollamb/src/widgets/style.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});
  _buildThemeModeWidget({
    required BuildContext context,
    required bool active,
    required String tooltip,
    required IconData icon,
    required Color selected,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: active ? selected : Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
      ),
    );
  }

  Widget _buildRow({required String label, required Widget action}) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, overflow: TextOverflow.ellipsis, maxLines: 1),
          Flexible(child: action),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreferencesVm>(
      builder: (vm) {
        return ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(scrollbars: false),
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              pageTitle("Settings"),
              const SizedBox(height: 25),
              Text("General", style: textTitle),
              const SizedBox(height: 10),

              _buildRow(
                label: "Text Scaler",
                action: SizedBox(
                  width: 150,
                  child: Slider.adaptive(
                    value: vm.settings.textScaleFactor,
                    onChanged: (value) {
                      vm.setTextScaleFactor(value);
                    },
                    min: 1.0,
                    max: 1.5,
                    divisions: 4,
                    label: vm.settings.textScaleFactor.toStringAsFixed(1),
                  ),
                ),
              ),

              _buildRow(
                label: "Color",
                action: SizedBox(
                  width: 140,
                  child: Dropdown<int>(
                    underline: false,
                    isExpanded: true,
                    value: vm.settings.themeColor.value,
                    onChanged: (v) => vm.changeTheme(Color(v!)),
                    items: [
                      Colors.red,
                      Colors.yellow,
                      Colors.green,
                      Colors.blue,
                      Colors.deepPurple,
                    ].map((e) {
                      return DropdownMenuItem(value: e.value, child: Container(height: 3, color: e));
                    }).toList(),
                  ),
                ),
              ),

              _buildRow(
                label: "Mode",
                action: SizedBox(
                  width: 150,
                  child: Row(
                    children: [
                      _buildThemeModeWidget(
                        context: context,
                        icon: Icons.dark_mode_outlined,
                        tooltip: "Dark",
                        active: vm.settings.themeMode == ThemeMode.dark.index,
                        selected: Theme.of(context).colorScheme.primary,
                        onPressed: () => vm.changeThemeMode(ThemeMode.dark),
                      ),
                      const SizedBox(width: 10),
                      _buildThemeModeWidget(
                        context: context,
                        icon: Icons.computer_outlined,
                        tooltip: "System",
                        active: vm.settings.themeMode == ThemeMode.system.index,
                        selected: Theme.of(context).colorScheme.primary,
                        onPressed: () => vm.changeThemeMode(ThemeMode.system),
                      ),
                      const SizedBox(width: 10),
                      _buildThemeModeWidget(
                        context: context,
                        icon: Icons.light_mode_outlined,
                        tooltip: "Light",
                        active: vm.settings.themeMode == ThemeMode.light.index,
                        selected: Theme.of(context).colorScheme.primary,
                        onPressed: () => vm.changeThemeMode(ThemeMode.light),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 20),
              Text("Conversation", style: textTitle),
              const SizedBox(height: 10),
              _buildRow(
                label: "Format",
                action: Dropdown<String>(
                  alignment: Alignment.centerRight,
                  value: vm.settings.responseFormat,
                  onChanged: (value) {
                    vm.changeResponseFormat(value!);
                  },
                  items: ['Markdown', 'Plaintext'].map((format) {
                    return DropdownMenuItem(value: format, child: Text(format.toUpperCase()));
                  }).toList(),
                ),
              ),
              _buildRow(
                label: "Code Theme",
                action: Dropdown<String>(
                  alignment: Alignment.centerRight,
                  value: vm.settings.codeSyntaxTheme,
                  onChanged: (value) {
                    vm.setSelectedCodeSyntaxTheme(value!);
                  },
                  items: [
                    'nord',
                    'solarized-light',
                    'solarized-dark',
                    'atom-one-light',
                    'atom-one-dark',
                    'kimbie.light',
                    'kimbie.dark',
                  ].map((theme) {
                    return DropdownMenuItem(
                      value: theme,
                      child: Text(theme.replaceAll(".", " ").replaceAll("-", " ").toUpperCase()),
                    );
                  }).toList(),
                ),
              ),
              // TODO
              // _buildRow(
              //   label: "Auto Title",
              //   action: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       if (vm.isAutoTitle)
              //         IconButton(
              //           onPressed: () {
              //             showDialog(
              //               context: context,
              //               builder: (context) {
              //                 return AlertDialog(
              //                   title: const Text("Auto Title"),
              //                   content: SizedBox(
              //                     width: 500,
              //                     child: Column(
              //                       mainAxisSize: MainAxisSize.min,
              //                       crossAxisAlignment: CrossAxisAlignment.stretch,
              //                       children: [
              //                         const Text(
              //                           "Template",
              //                         ),
              //                         const SizedBox(height: 10),
              //                         TextField(
              //                           controller: TextEditingController(
              //                             text: "Please convert the text below into a single, concise title with no more than 5 words. Do not answer or explain anything. ONLY respond with the title in English and do not exceed 5 words.\n\nText:\n\$text",
              //                           ),
              //                           maxLines: 9,
              //                           minLines: 9,
              //                           decoration: const InputDecoration(filled: true),
              //                         )
              //                       ],
              //                     ),
              //                   ),
              //                   actionsAlignment: MainAxisAlignment.spaceBetween,
              //                   actions: [
              //                     Row(
              //                       mainAxisSize: MainAxisSize.min,
              //                       children: [
              //                         const Text("Model : "),
              //                         Dropdown<String>(
              //                           isDense: true,
              //                           items: List<String>.from(
              //                             OllamaVm.find.server.models.map((e) => e.name).toList()..insert(0, "Auto Model"),
              //                           ).map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase()))).toList(),
              //                           value: vm.modelAutoTitle,
              //                           onChanged: (v) {
              //                             vm.setModelAutoTitle(v!);
              //                           },
              //                         ),
              //                       ],
              //                     ),
              //                     TextButton(onPressed: () {}, child: const Text("Save")),
              //                   ],
              //                 );
              //               },
              //             );
              //           },
              //           icon: const Icon(Icons.settings),
              //         ),
              //       Transform.scale(
              //         scale: 0.7,
              //         child: Switch.adaptive(
              //           applyCupertinoTheme: true,
              //           value: vm.isAutoTitle,
              //           onChanged: (v) {
              //             vm.setIsGenerateTitle(v);
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              if (Core.platform.isMacOS)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 20),
                    Text("Others", style: textTitle),
                    const SizedBox(height: 10),
                    _buildRow(
                      label: "Data Path",
                      action: GestureDetector(
                        child: Text(
                          DESKTOP_PATH,
                          style: TextStyle(color: Theme.of(context).colorScheme.primary),
                        ),
                        onTap: () async {
                          Process.runSync('open', [DESKTOP_PATH]);
                        },
                      ),
                    ),
                    // TODO
                    // _buildRow(
                    //   label: "Default Settings",
                    //   action: const TextButton(onPressed: null, child: Text("Reset")),
                    // ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
