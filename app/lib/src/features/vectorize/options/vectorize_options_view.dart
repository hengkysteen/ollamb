import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:ollamb/src/features/vectorize/options/vectorize_options_vm.dart';

class VectorizeOptionsView extends StatelessWidget {
  final void Function(int chunkRange, double threshold) onDone;
  final int? initRange;
  final double? initThreshold;
  final String onDoneText;
  const VectorizeOptionsView({
    super.key,
    required this.onDone,
    this.initRange,
    this.initThreshold,
    this.onDoneText = "Activate",
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: VectorizeOptionsVm(initRange: initRange, initThreshold: initThreshold),
      builder: (vm) {
        return AlertDialog(
          title: const Text("Vectorize Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      "Range : ${vm.chunkRange.toString()} ",
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: Slider(
                      value: vm.chunkRange.toDouble(),
                      min: 1,
                      max: 6,
                      divisions: 5,
                      onChanged: (value) {
                        vm.updateOptions(chunkRange: value.toInt());
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 120, child: Text("Treshold : ${vm.threshold}")),
                  SizedBox(
                    width: 180,
                    child: Slider(
                      value: vm.threshold,
                      min: 0.5,
                      max: 0.9,
                      divisions: 4,
                      onChanged: (value) {
                        vm.updateOptions(threshold: value);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: vm.resetOptions, child: const Text("Reset")),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onDone(vm.chunkRange, vm.threshold);
                Future.delayed(const Duration(milliseconds: 200), () {
                  vm.resetOptions();
                });
              },
              child: Text(onDoneText),
            ),
          ],
        );
      },
    );
  }
}
