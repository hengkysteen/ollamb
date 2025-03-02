import 'package:get/get.dart';
import 'package:ollamb/src/features/prompts/data/default.dart';
import 'package:ollamb/src/features/prompts/data/prompt_model.dart';
import 'package:ollamb/src/features/prompts/data/promtp_repository.dart';

class PromptsVm extends GetxController {
  final PromtpRepository _repository;
  final int type;
  PromptsVm(this._repository, {required this.type});

  List<Prompt> promptsList = [...defaultPrompts.map((e) => Prompt.fromJson(e))];
  List<Prompt> prompts = [];

  int activeFilter = 0;
  int selectedItem = 0;

  bool get isValid => type == 2 && prompts[selectedItem].type == "user" || type == 1 && prompts[selectedItem].type == "system";

  void clear() {
    promptsList.clear();
    promptsList = [...defaultPrompts.map((e) => Prompt.fromJson(e))];
    update();
  }

  void setSelectedItem(int index) {
    selectedItem = index;
    update();
  }

  void filter(int type) {
    activeFilter = type;
    selectedItem = 0;
    if (activeFilter == 0) {
      prompts = promptsList;
    }
    if (activeFilter == 1) {
      prompts = promptsList.where((e) => e.type == "system").toList();
    }
    if (activeFilter == 2) {
      prompts = promptsList.where((e) => e.type == "user").toList();
    }
    prompts.sort((e1, e2) => e1.name.compareTo(e2.name));
    update();
  }

  Future<void> install({required void Function() onSuccess, required void Function(String) onError}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final data = await _repository.getFromRemote();
      _repository.addAll(data);
      getPrompt();
      filter(type);
      onSuccess();
    } catch (e) {
      if (e.toString().contains("SocketException") || e.toString().contains("ClientException")) {
        onError("Internet connection error");
      } else {
        onError("Something when wrong");
      }
      return;
    }
  }

  Future<void> deleteAll() async {
    await _repository.deleteAll();
    clear();
    filter(type);
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
    getPrompt();
    filter(type);
  }

  Future<void> getPrompt() async {
    clear();
    promptsList.addAll(await _repository.getPrompts());
    filter(type);
  }

  @override
  void onInit() async {
    await getPrompt();
    super.onInit();
  }
}
