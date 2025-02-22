import 'dart:io';
import 'package:ollamb/src/core/dm.dart';
import 'package:ollamb/src/services/file_service.dart';

class OllamaGuiModelExport {
  final FileService _fileService;
  OllamaGuiModelExport(this._fileService);

  Future<void> _createModelFile(String dir, String name, String modelFile, List<String> ggufPath) async {
    String modelFileString = replaceFromPaths(removeCommentsBeforeFrom(modelFile), ggufPath);
    final newModelFilePath = "$dir$name--Modelfile";
    final file = File(newModelFilePath);
    await file.writeAsString(modelFileString);
    final xFileModelFile = XFile(file.path);
    await xFileModelFile.saveTo(newModelFilePath);
  }

  Future<void> _createInfo(String dir, String originalModelName, Map<String, dynamic> details) async {
    final infoPath = "${dir}model-info.txt";
    String data = "Model Name : $originalModelName\nDetails :\n$details";
    final fileInfo = File(infoPath);
    await fileInfo.writeAsString(data);
    final xFileInfo = XFile(fileInfo.path);
    await xFileInfo.saveTo(infoPath);
  }

  String _formatedFolderName(String input) {
    if (input.isEmpty) {
      throw Exception("Input can't be empty");
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString().substring(6);

    List<String> parts = input.split(":");
    String name = parts.first.toLowerCase();
    String tag = parts.length > 1 ? parts.last.toLowerCase() : "latest";

    return "${name}__${tag}__$id";
  }

  Future<void> _startExport(
    String modelName,
    String modelFile,
    String path,
    void Function(String error)? onError,
    Map<String, dynamic> details,
    void Function(String path) onDone,
  ) async {
    List<String> ggufFilesPath = [];

    final List<String> blobsPath = findBlob(modelFile);
    final name = modelName.contains(":") ? modelName.split(":").first : modelName;
    final folderName = _formatedFolderName(modelName);

    try {
      final dir = await _fileService.createDir("$path/$folderName/");
      for (var i = 0; i < blobsPath.length; i++) {
        final blob = blobsPath[i];
        XFile file = XFile(blob);
        final ggufFile = "$dir$name--model-${i + 1}.gguf";
        ggufFilesPath.add('$name--model-${i + 1}.gguf');
        await file.saveTo(ggufFile);
      }
      await _createModelFile(dir!, name, modelFile, ggufFilesPath);
      await _createInfo(dir, modelName, details);
      onDone(dir);
    } catch (e) {
      onError?.call(e.toString());
    }
  }

  Future<void> export({required String model, required void Function() onStart, required void Function(String path) onDone, void Function(String error)? onError}) async {
    final path = await _fileService.selectPath();
    if (path == null) return;
    onStart();
    try {
      final data = await DM.ollamaModule.ollamax.showModel(model);
      final modelFile = data["modelfile"];
      final modelDetails = data['details'];
      await _startExport(model, modelFile, path, onError, modelDetails, (path) {
        onDone(path);
      });
    } catch (e) {
      onError?.call(e.toString());
      return;
    }
  }

  String removeCommentsBeforeFrom(String modelFileContent) {
    final lines = modelFileContent.split('\n');
    bool foundFrom = false;
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (!foundFrom && line.startsWith('#')) {
        lines.removeAt(i);
        i--;
      } else if (line.startsWith('FROM')) {
        foundFrom = true;
      }
    }
    return lines.join('\n');
  }

  String replaceFromPaths(String modelFileContent, List<String> newPaths) {
    final lines = modelFileContent.split('\n');
    int pathIndex = 0;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].trim().startsWith('FROM') && pathIndex < newPaths.length) {
        lines[i] = 'FROM ./${newPaths[pathIndex]}';
        pathIndex++;
      }
    }
    return lines.join('\n');
  }

  List<String> findBlob(String modelFileContent) {
    final List<String> blobPaths = [];
    final lines = modelFileContent.split('\n');
    for (var line in lines) {
      if (line.trim().startsWith('FROM')) {
        final path = line.substring(5).trim();
        if (path.isNotEmpty) {
          blobPaths.add(path);
        }
      }
    }
    return blobPaths;
  }
}
