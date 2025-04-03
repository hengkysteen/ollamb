import 'package:flutter/material.dart';
import 'package:ollamb/src/core/modules/preferences/preferences_vm.dart';
import 'package:ollamb/src/widgets/icons.dart';
import 'package:ollamb/src/widgets/style.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          IconPng(icon: PreferencesVm.find.isDark ? IconsPng.logoWhite : IconsPng.logoBlack, size: 60),
          const SizedBox(height: 6),
          Text("OLLAMB", style: textTitle),
          const SizedBox(height: 20),
          const Text("Contact:", style: TextStyle(fontWeight: FontWeight.bold)),
          const Text("hengkysteen@gmail.com"),
          const SizedBox(height: 20),
          const Text("Links:", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => launchUrlString("https://github.com/hengkysteen/ollamb"),
            child: const Text("GitHub Repository", style: TextStyle(color: Colors.blue)),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => launchUrlString("https://github.com/hengkysteen/ollamb/issues"),
            child: const Text("Report Issues", style: TextStyle(color: Colors.blue)),
          ),
          const SizedBox(height: 6),
          const InkWell(onTap: null, child: Text("FAQ - (Soon)")),
        ],
      ),
    );
  }
}
