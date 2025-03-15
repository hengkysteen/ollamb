import 'package:flutter/material.dart';
import 'package:ollamb/src/widgets/page_dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageDialog(
      closeButton: false,
      contentPadding: 32,
      title: "About",
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SelectionArea(
          child: Column(
            children: [
              const Text("OLLAMB is a simple and easy-to-use client for Ollama, built with Flutter. It is fully open-source and comes with various features. A prebuilt version is available for macOS and Web, while other platforms can be built manually."),
              const SizedBox(height: 20),
              const Text(
                "Contact:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
        ),
      ),
    );
  }
}
