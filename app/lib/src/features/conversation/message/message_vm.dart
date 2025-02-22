import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:ollamax/ollamax.dart';
import 'package:ollamb/src/core/modules/conversation/models/message.dart';
import 'package:ollamb/src/core/modules/conversation/view_models/conversation_vm.dart';

class MessageVm extends GetxController {
  final FlutterTts tts;
  MessageVm(this.tts);

  String speachId = "";
  bool isSpeachPlayed = false;
  String copyId = "";
  bool isCopied = false;
  String codeSyntaxId = "";
  bool isCodeSyntaxCopied = false;
  int seedCount = 100;

  void resendLastMessage(Message message) async {
    final m = message;
    deleteMessage(message);
    ConversationVm.find.sendMessage(m.prompt, m.model, options: OllamaxOptions(seed: seedCount += 20, temperature: 1));
  }

  Future<void> copyMessage(Message message) async {
    copyId = message.id;
    isCopied = true;
    update();
    await Clipboard.setData(ClipboardData(text: message.content));
    Future.delayed(const Duration(seconds: 1), () {
      copyId = "";
      isCopied = false;
      update();
    });
  }

  String getResponseInfo(Message message) {
    if (message.response == null) return "";
    if (message.isDone == true && message.response!.done == false) return "Stopped";
    if (message.response!.doneReason == "error") return "Error";
    final infoGenerate = """
Eval Count : ${message.response!.evalCount}
Eval Duration : ${formatDuration(message.response!.evalDuration ?? 0)}
Load Duration : ${formatDuration(message.response!.loadDuration!)}
Prompt Eval Count : ${message.response!.promptEvalCount}
Prompt Eval Duration : ${formatDuration(message.response!.promptEvalDuration!)}
Total Duration : ${formatDuration(message.response!.totalDuration!)}""";
    return infoGenerate;
  }

  Future<void> deleteMessage(Message message) async {
    await ConversationVm.find.deleteMessage(message);
  }

  Future<void> copyCodeSytax(String code, String id) async {
    codeSyntaxId = id;
    isCodeSyntaxCopied = true;
    update();
    await Clipboard.setData(ClipboardData(text: code));
    Future.delayed(const Duration(seconds: 1), () {
      codeSyntaxId = "";
      isCodeSyntaxCopied = false;
      update();
    });
  }

  Future<void> playSpeach(Message message) async {
    speachId = message.id;
    isSpeachPlayed = true;
    update();
    await tts.awaitSpeakCompletion(true);
    await tts.speak(removeEmojis(message.content));
    speachId = "";
    isSpeachPlayed = false;
    update();
  }

  Future<void> stopSpeach() async {
    await tts.stop();
    speachId = "";
    isSpeachPlayed = false;
    update();
  }

  String removeEmojis(String text) {
    final emojiRegex = RegExp(
        r'[\u{1F600}-\u{1F64F}'
        r'\u{1F300}-\u{1F5FF}'
        r'\u{1F680}-\u{1F6FF}'
        r'\u{1F1E0}-\u{1F1FF}'
        r'\u{2600}-\u{26FF}'
        r'\u{2700}-\u{27BF}'
        r'\u{FE00}-\u{FE0F}'
        r'\u{1F900}-\u{1F9FF}'
        r'\u{1FA70}-\u{1FAFF}'
        r'\u{200D}'
        r'\u{2069}-\u{206F}'
        r'\u{20E3}'
        r'\u{2B50}-\u{2B55}'
        r']',
        unicode: true);
    return text.replaceAll(emojiRegex, '');
  }

  String formatDuration(int nanoseconds) {
    if (nanoseconds >= 1e9) {
      return "${(nanoseconds / 1e9).round()} s";
    } else {
      return "${(nanoseconds / 1e6).round()} ms";
    }
  }

  static MessageVm get find => Get.find();
}
