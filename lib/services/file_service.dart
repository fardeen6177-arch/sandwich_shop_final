import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileService {
  // Use the platform-specific application documents directory.
  Future<File> _fileFor(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$name');
  }

  Future<void> save(String name, String content) async {
    final file = await _fileFor(name);
    await file.writeAsString(content);
  }

  Future<String?> read(String name) async {
    final file = await _fileFor(name);
    if (await file.exists()) {
      return file.readAsString();
    }
    return null;
  }
}
