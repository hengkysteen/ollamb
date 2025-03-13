import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_model.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_module.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_vm.dart';
import 'package:ollamb/src/features/ollama_gui/ollama_gui_vm.dart';
import 'package:ollamb/src/features/ollama_gui/add_server/add_server_view.dart';
import 'package:ollamb/src/features/ollama_gui/widgets/model_list.dart';
import 'package:ollamb/src/widgets/model_icon.dart';
import 'package:ollamb/src/widgets/page_dialog.dart';
import 'package:ollamb/src/widgets/style.dart';

class OllamaGuiView extends StatelessWidget {
  final OllamaModule ollamaModule;
  const OllamaGuiView({super.key, required this.ollamaModule});

  Widget _widgetServerTitle(BuildContext context) {
    return Row(
      children: [
        Text("Servers", style: textTitle),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AddServerView(
                  ollamaRepository: ollamaModule.repository,
                  onData: (host) async {
                    await OllamaVm.find.addServer(OllamaServer(host: host));
                  },
                );
              },
            );
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _widgetServers(BuildContext context, OllamaGuiVm ollamaGuiVm) {
    return GetBuilder<OllamaVm>(
      builder: (_) {
        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _widgetServerTitle(context),
              Container(
                constraints: const BoxConstraints(maxHeight: 150),
                child: ListView(
                  shrinkWrap: true,
                  children: List.generate(ollamaGuiVm.server.length, (index) {
                    final server = ollamaGuiVm.server[index];
                    return ListTile(
                      visualDensity: VisualDensity.comfortable,
                      selected: server.host.name == ollamaGuiVm.selectedServer?.host.name,
                      leading: ModelWidget.icon("ollama", isActive: server.host.name == ollamaGuiVm.selectedServer?.host.name, size: 26),
                      title: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(server.host.name),
                          if (server.host.version.isNotEmpty) Text(" - v${server.host.version}", style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      subtitle: Text(
                        "${server.host.url} ${OllamaVm.find.server.host.name == server.host.name ? '(main)' : ''}",
                      ),
                      onTap: () async {
                        await ollamaGuiVm.getModels(server);
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PopupMenuButton(
                            tooltip: "",
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  enabled: OllamaVm.find.servers.length > 1 && OllamaVm.find.server.host.name != server.host.name,
                                  child: const Text("Delete "),
                                  onTap: () async {
                                    await OllamaVm.find.deleteServer(server);
                                  },
                                ),
                              ];
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          secondChild: _widgetServerTitle(context),
          crossFadeState: ollamaGuiVm.isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageDialog(
      title: "Ollama",
      contentPadding: 32,
      child: GetBuilder<OllamaGuiVm>(
        init: OllamaGuiVm(),
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _widgetServers(context, controller),
              Expanded(
                child: OllamaGuiModelList(ollamaRepository: ollamaModule.repository),
              ),
            ],
          );
        },
      ),
    );
  }
}
