import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChunkInputView extends StatelessWidget {
  final String? data;
  final void Function(String)? onFinnish;
  const ChunkInputView({super.key, this.data, this.onFinnish});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 600,
        height: 600,
        child: Material(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: GetBuilder(
              init: ChunkInputVm(data),
              builder: (vm) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: vm.chunk,
                        autofocus: true,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () {
                        if (vm.chunk.text.trim().isEmpty || vm.chunk.text.length < 3) return;
                        Navigator.pop(context);
                        onFinnish?.call(vm.chunk.text);
                      },
                      label: Text(data == null ? "ADD" : "UPDATE"),
                      icon: const Icon(Icons.add),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ChunkInputVm extends GetxController {
  final String? data;
  ChunkInputVm(this.data);
  final TextEditingController chunk = TextEditingController();

  @override
  void onInit() {
    if (data != null) {
      chunk.text = data!;
    }
    super.onInit();
  }
}
