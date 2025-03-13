import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ollamb/src/features/conversation/conversation_view.dart';
import 'package:ollamb/src/features/conversation/input/input_view.dart';
import 'package:ollamb/src/features/settings/settings_view.dart';
import 'package:ollamb/src/services/file_service.dart';
import 'package:ollamb/src/services/platfrom.dart';
import 'package:ollamb/src/features/shortcuts/body_shortcut.dart';
import 'package:ollamb/src/services/keyboard_shortcuts.dart';
import 'package:ollamb/src/ui/pages/about_page.dart';
import 'package:ollamb/src/ui/pages/conversation_page.dart';
import 'package:ollamb/src/ui/pages/menus_page.dart';
import 'package:ollamb/src/ui/widgets/desktop_layout/controller.dart';
import 'package:ollamb/src/widgets/style.dart';

class Core {
  static final Core _instance = Core._internal();

  factory Core() => _instance;

  Core._internal();

  static final PlatfromService platform = PlatfromService();

  static final FocusNode bodyNode = FocusNode();

  static final keyboard = KeyboardShortcuts();

  static final bodyEvent = BodyShortcut(keyboard);

  static final fileService = FileService();

  static final tts = FlutterTts();

  static final DesktopLayoutController layout = DesktopLayoutController();

  static final Widget menusPage = MenusPage(
    items: [
      MenuItem(
        name: "Settings",
        icon: (ctx, i) => Icon(CupertinoIcons.settings, color: activeColor(ctx, i == 0)),
        page: const SettingsView(),
      ),
      MenuItem(
        name: "About",
        icon: (ctx, i) => Icon(CupertinoIcons.info, color: activeColor(ctx, i == 1)),
        page: const AboutPage(),
      ),
    ],
  );

  static const Widget conversationPage = ConversationPage(body: ConversationView(), input: InputView());
}
