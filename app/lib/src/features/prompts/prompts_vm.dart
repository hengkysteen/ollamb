import 'package:get/get.dart';
import 'package:ollamb/src/features/prompts/data/data.dart';

class PromptsVm extends GetxController {
  final int type;
  PromptsVm({required this.type});

  List<Map> data = List<Map>.from(dataDefault);
  int activeFilter = 0;
  int selectedItem = 0;

  bool get isValid => type == 2 && data[selectedItem]['type'] == "user" || type == 1 && data[selectedItem]['type'] == "system";

  void setSelectedItem(int index) {
    selectedItem = index;
    update();
  }

  void filter(int type) {
    activeFilter = type;
    selectedItem = 0;
    if (activeFilter == 0) {
      data = dataDefault;
    }
    if (activeFilter == 1) {
      data = dataDefault.where((e) => e['type'] == "system").toList();
    }
    if (activeFilter == 2) {
      data = dataDefault.where((e) => e['type'] == "user").toList();
    }
    update();
  }

  @override
  void onInit() {
    filter(type);
    super.onInit();
  }
}
