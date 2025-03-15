import 'package:get/get.dart';

class VectorizeOptionsVm extends GetxController {
  final int? initRange;
  final double? initThreshold;

  VectorizeOptionsVm({this.initRange, this.initThreshold});
  double threshold = 0.6;
  int chunkRange = 3;

  void updateOptions({double? threshold, int? chunkRange}) {
    if (threshold != null) this.threshold = threshold;
    if (chunkRange != null) this.chunkRange = chunkRange;
    update();
  }

  void resetOptions() {
    threshold = 0.6;
    chunkRange = 3;
    update();
  }

  @override
  void onInit() {
    if (initRange != null) {
      chunkRange = initRange!;
    }
    if (initThreshold != null) {
      threshold = initThreshold!;
    }
    super.onInit();
  }
}
