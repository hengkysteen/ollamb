import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/modules/preferences/preferences_vm.dart';
import 'package:ollamb/src/features/conversation/input/widgets/attachment.dart';

class ConversationPage extends StatelessWidget {
  final Widget body;
  final Widget input;
  const ConversationPage({super.key, required this.body, required this.input});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreferencesVm>(builder: (vm) {
      return Container(
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Column(children: [Expanded(child: body), input]),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 130),
                child: const InputMessageAttachmentWidget(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
