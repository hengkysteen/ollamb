class DesktopLayoutController {
  final ZTab? initTab;

  DesktopLayoutController({this.initTab}) {
    tab = initTab ?? ZTab(index: 0);
  }
  void Function(void Function())? _state;
  late ZTab tab;
  bool isCollapsed = false;
  void toggleCollapse() {
    isCollapsed = !isCollapsed;
    _update();
  }

  void init(state) {
    if (_state != null) return;
    _state = state;
  }

  void _update() {
    if (_state == null) {
      throw Exception("State has not been initialized. Call init() first.");
    }
    _state!(() {});
  }

  void changeTab(int index, {dynamic data}) {
    tab.index = index;
    tab.data = data;
    _update();
  }
}

class ZTab {
  int index;
  dynamic data;
  ZTab({required this.index, this.data});
}
