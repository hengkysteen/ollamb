import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ollamax/ollamax.dart';

class ModelOptionsVm extends GetxController {
  static final OllamaxOptions _defaultOptions = OllamaxOptions(
    mirostat: 0,
    mirostatEta: 0.1,
    mirostatTau: 5.0,
    numCtx: 2048,
    repeatLastN: 64,
    repeatPenalty: 1.1,
    temperature: 0.8,
    seed: 0,
    stop: null,
    tfsZ: 1.0,
    numPredict: -1,
    topK: 40,
    topP: 0.9,
    minP: 0.0,
  );

  OllamaxOptions get defaultOptions => _defaultOptions;

  OllamaxOptions options = OllamaxOptions().copyFrom(_defaultOptions);

  final TextEditingController systemPromptController = TextEditingController();
  final TextEditingController jsonOptionController = TextEditingController();

  String systemPrompt = "";

  String optionsMessageId = "";
  bool isOptionsUpdated = false;

  int optionShow = 0;
  bool isActivate = false;
  bool get isOptionsEqual => _areMapsEqual(options.toJson(), defaultOptions.toJson());

  String keepAliveDuration = "m";

  String get keepAlive {
    String value = keepAliveValue.text.trim().isEmpty ? "5" : keepAliveValue.text.trim();
    return '$value$keepAliveDuration';
  }

  bool get isValidToActivated {
    return isOptionsEqual && systemPrompt.trim().isEmpty && (keepAlive == "5m" || keepAliveValue.text.trim().isEmpty);
  }

  final TextEditingController keepAliveValue = TextEditingController(text: "5");

  void setKeepAlive(String value) {
    keepAliveValue.text = value;
    update();
  }

  void setOptionShow(int value) {
    optionShow = value;
    options = OllamaxOptions().copyFrom(_defaultOptions);

    update();
    initJsonOptions();
  }

  void setMessageId(String id) {
    optionsMessageId = id;
  }

  bool _areMapsEqual(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    if (map1.length != map2.length) return false;
    for (var key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) {
        return false;
      }
    }
    return true;
  }

  void toggleActivate() {
    Future.delayed(const Duration(milliseconds: 200), () {
      isActivate = !isActivate;
      update();
    });
  }

  void setSystemPrompt(String value) {
    systemPrompt = value;
    if (keepAliveValue.text.isEmpty) {
      keepAliveValue.text = "5";
    }
    update();
  }

  VoidCallback updateState(VoidCallback callback) {
    return () {
      callback();
      update();
    };
  }

  void updaetUptions(OllamaxOptions options) {
    this.options = options;
    update();
  }

  void initJsonOptions() {
    jsonOptionsError = "";
    jsonOptionController.clear();
    const encoder = JsonEncoder.withIndent('  ');
    jsonOptionController.text = encoder.convert(_defaultOptions.toJson());
    update();
  }

  String jsonOptionsError = "";

  void setJsonOptions(String value) {
    try {
      final data = OllamaxOptions.fromJson(json.decode(value));
      jsonOptionsError = "";
      updaetUptions(data);
    } catch (e) {
      jsonOptionsError = e.toString();
      updaetUptions(_defaultOptions);
    }
    update();
  }

  void resetDefaut() {
    systemPromptController.clear();
    systemPrompt = "";
    options = OllamaxOptions().copyFrom(_defaultOptions);
    isActivate = false;
    keepAliveValue.text = "5";
    keepAliveDuration = "m";
    update();
  }

  @override
  void onInit() {
    initJsonOptions();
    super.onInit();
  }

  static ModelOptionsVm get find => Get.find();
}
