import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/dm.dart';
import 'package:ollamb/src/features/ollama_gui/model_import/import_view.dart';
import 'package:ollamb/src/features/ollama_gui/ollama_gui_vm.dart';

class AddModelViewVm extends GetxController {}

class AddModelView extends StatelessWidget {
  const AddModelView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TabBar(
            tabs: [
              Tab(child: Text("Pull")),
              Tab(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("ModelFile"),
                    Text("ollama < 0.5.4", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Create"),
                    Text("ollama > 0.5.5", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                const Center(child: Text("Soon")),
                ImportView(
                  ollamaRepository: DM.ollamaModule.repository,
                  onImport: () {
                    OllamaGuiVm.find.getModels(OllamaGuiVm.find.selectedServer);
                  },
                ),
                const Center(child: Text("Soon")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
