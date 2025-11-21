import 'dart:async';
import 'dart:io';

class FileService {
  // Uses the system temp directory for simplicity in this exercise.
  // For production, use path_provider to get application documents directory.
  Future<File> _fileFor(String name) async {
    final dir = Directory.systemTemp;
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
