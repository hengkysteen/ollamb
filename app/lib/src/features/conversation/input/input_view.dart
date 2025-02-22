import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:ollamb/src/core/modules/conversation/view_models/conversation_vm.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_vm.dart';
import 'package:ollamb/src/core/modules/preferences/preferences_vm.dart';
import 'package:ollamb/src/features/conversation/input/input_vm.dart';
import 'package:ollamb/src/features/conversation/input/widgets/shortcuts_info.dart';
import 'package:ollamb/src/features/model_list/model_list_view.dart';
import 'package:ollamb/src/widgets/model_icon.dart';
import 'package:wee_kit/wee_kit.dart';
import 'widgets/button_options.dart';
import 'widgets/button_send_message.dart';
import 'widgets/button_upload.dart';
import 'widgets/input_textfield.dart';

class InputView extends StatelessWidget {
  const InputView({super.key, required});

  Widget _inputTop(BuildContext context) {
    return GetBuilder<OllamaVm>(
      builder: (ollamaVm) {
        return SizedBox(
          height: 40,
          child: Stack(
            children: [
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  OptionsButton(model: OllamaVm.find.model?.name),
                  ollamaVm.model != null
                      ? Row(
                          children: [
                            const SizedBox(width: 10),
                            Tooltip(
                              preferBelow: false,
                              message: ollamaVm.model!.name,
                              child: ModelWidget.icon(ollamaVm.model!.name, size: 10, isActive: true),
                            ),
                            const SizedBox(width: 6),
                            Builder(
                              builder: (context) {
                                final width = MediaQuery.of(context).size.width;
                                final int length = width > 800 ? 30 : 20;
                                return ModelWidget.name(
                                  ollamaVm.model!.name.truncate(length).toUpperCase(),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                          ],
                        )
                      : const Row(
                          children: [
                            SizedBox(width: 6),
                            Text("No Selected Model", style: TextStyle(color: Colors.grey)),
                            SizedBox(width: 20),
                          ],
                        ),
                  const VerticalDivider(width: 0, endIndent: 10, indent: 10),
                  // USER PROMPTS BUTTON TODO @features/prompts
                ],
              ),
              const Align(alignment: Alignment.centerRight, child: ShortcutsInfo())
            ],
          ),
        );
      },
    );
  }

  Widget _inputBottom(BuildContext context) {
    return Row(
      children: [
        CupertinoButton(
          key: const Key("MODEL_LIST_BUTTON"),
          padding: EdgeInsets.zero,
          onPressed: () async {
            showModalBottomSheet(context: context, builder: (context) => const ModelListView());
          },
          child: const Icon(CupertinoIcons.collections),
        ),
        const SizedBox(width: 10),
        GetBuilder<ConversationVm>(
          builder: (cVm) {
            return InputTextfield(
              enabled: cVm.message == null || cVm.message?.conversationId == Core.layout.tab.data,
              focusNode: InputVm.find.inputFocusNode,
              textEditingController: InputVm.find.textEditingController,
              prefixIcon: const UploadButton(),
            );
          },
        ),
        const SizedBox(width: 10),
        SendMessageButton(textEditingController: InputVm.find.textEditingController)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: InputVm(OllamaVm.find),
      builder: (_) {
        return Column(
          children: [
            Card(
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey, width: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0.5,
              margin: EdgeInsets.only(
                bottom: 10,
                left: PreferencesVm.find.getPadding(context),
                right: PreferencesVm.find.getPadding(context),
              ),
              child: Container(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [_inputTop(context), _inputBottom(context)],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
