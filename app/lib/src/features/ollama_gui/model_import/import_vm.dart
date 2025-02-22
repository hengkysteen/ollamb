import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ollamb/src/core/modules/ollama/ollama_repository.dart';
import 'package:ollamb/src/services/file_service.dart';

class OllamaGuiModelImportVm extends GetxController {
  final OllamaRepository _ollamaRepository;
  final FileService _fileService;
  OllamaGuiModelImportVm(this._ollamaRepository, this._fileService);

  final TextEditingController modelNameController = TextEditingController();
  final TextEditingController modelTagController = TextEditingController();
  final TextEditingController modelFileController = TextEditingController();
  final FocusNode modelFileFocusNode = FocusNode();

  XFile? modelFilePath;

  int importMethod = 0;

  bool isImporting = false;
  bool get isValid {
    if (importMethod == 0) {
      return modelNameController.text.trim().isNotEmpty && modelFileController.text.trim().isNotEmpty;
    }
    return modelFilePath != null && modelNameController.text.trim().isNotEmpty;
  }

  void reset() {
    modelFileController.clear();
    modelNameController.clear();
    modelTagController.clear();
    modelFilePath = null;
    update();
  }

  // Future<void> pickFile(BuildContext context) async {
  //   final file = await _fileSelectorService.selectDocument(ext: ['gguf']);
  //   if (file == null) return;
  //   modelNameController.text = file.name.split(".").first;
  //   modelFileController.text = "FROM  ${file.path}";
  //   String currentText = modelFileController.text;
  //   modelFileController.text = '$currentText\n';
  //   int cursorPosition = currentText.length + 1;
  //   modelFileController.selection = TextSelection.fromPosition(TextPosition(offset: cursorPosition));
  //   if (!context.mounted) return;
  //   FocusScope.of(context).requestFocus(modelFileFocusNode);
  // }

  Future<void> selectModelFile(BuildContext context) async {
    final file = await _fileService.select();
    if (file == null) return;
    modelFilePath = file;
    update();
  }

  Future<void> import() async {
    final name = modelNameController.text.trim().toLowerCase();
    final tag = modelTagController.text.trim().toLowerCase();
    final modelName = "$name${tag.isNotEmpty ? ':$tag' : ''}";

    Map<String, dynamic> request = {'model': modelName};

    if (importMethod == 0) {
      request['modelfile'] = modelFileController.text;
    } else if (importMethod == 1 && modelFilePath != null) {
      request['path'] = modelFilePath!.path;
    }

    try {
      await _ollamaRepository.createModel(request);
      reset();
    } catch (e) {
      print("ERRRO $e");
      rethrow;
    }
  }
}
