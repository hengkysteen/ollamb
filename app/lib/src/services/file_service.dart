import 'dart:io';
import 'package:ollamb/src/core/configs/path.dart';
import 'package:ollamb/src/core/core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_selector/file_selector.dart';
export 'package:file_selector/file_selector.dart' show XFile;

class FileService {
  Future<XFile?> selectImage() async {
    const XTypeGroup images = XTypeGroup(label: 'images', extensions: <String>['jpg', 'png']);
    return await openFile(acceptedTypeGroups: [images]);
  }

  Future<XFile?> selectDocument({List<String>? ext}) async {
    final XTypeGroup custom = XTypeGroup(extensions: ext);

    const XTypeGroup documents = XTypeGroup(extensions: [], mimeTypes: ["text/markdown", "application/json", "text/csv", "text/plain"]);
    return await openFile(acceptedTypeGroups: [ext == null || ext.isEmpty ? documents : custom]);
  }

  Future<XFile?> select() async {
    return await openFile();
  }

  Future<String?> selectPath({String confirmButtonText = "Select"}) async {
    return await getDirectoryPath(confirmButtonText: confirmButtonText);
  }

  Future<String?> createDir(String path) async {
    if (!Core.platform.isWeb) {
      try {
        Directory directory = Directory(path);
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
        return directory.path;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<String?> createPath(String? path) async {
    if (!Core.platform.isWeb) {
      Directory directory;
      try {
        if (Core.platform.isDesktop) {
          directory = Directory('$DESKTOP_PATH/$path');
        } else {
          final appDir = await getApplicationDocumentsDirectory();
          directory = Directory('${appDir.path}/$path');
        }
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        return directory.path;
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
