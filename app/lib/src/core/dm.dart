import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_module.dart';
import 'package:ollamb/src/core/modules/preferences/preferences_module.dart';
import 'package:ollamb/src/core/modules/conversation/data/conversation_repository.dart';
import 'package:ollamb/src/core/modules/conversation/data/conversation_storage.dart';
import 'package:ollamb/src/core/modules/conversation/view_models/conversation_vm.dart';
import 'package:ollamb/src/features/vectorize/data/vectorize_storage.dart';
import 'package:ollamb/src/features/vectorize/vectorize_vm.dart';
import 'package:ollamb/src/features/prompts/data/prompt_storage.dart';

class DM {
  static final DM _instance = DM._internal();
  factory DM() => _instance;
  DM._internal();

  static late final OllamaModule ollamaModule;

  static late final PromptStorage promptStorage;

  static Future<void> init() async {
    try {
      Get.isLogEnable = true;
      await Hive.initFlutter();

      // OLLAMA SETUP
      ollamaModule = OllamaModule(Core.fileService);
      await ollamaModule.setup();

      // PREFERENCE SETUP
      final prefsModule = PreferencesModule(Core.fileService);
      await prefsModule.setup();

      // CONVERSATION SETUP
      final storage = ConversationStorage(Core.fileService);
      await storage.init();
      Get.put(ConversationVm(ConversationRepository(storage), ollamaModule.repository));
      await ConversationVm.find.getMetaConversations();

      // PROMPTS SETUP
      promptStorage = PromptStorage(Core.fileService);
      await promptStorage.init();

      // VECTORIZE SETUP
      final vectorStorage = VectorizeStorage(Core.fileService);
      await vectorStorage.init();
      Get.put(VectorizeVm(ollamaModule.ollamax, vectorStorage));
    } catch (e) {
      // ERRROR
    }
  }
}
