import 'package:flutter/foundation.dart';

class DevLogger extends ChangeNotifier {
  DevLogger._privateConstructor();
  static final DevLogger _instance = DevLogger._privateConstructor();
  static DevLogger get instance => _instance;

  final List<String> _messages = [];

  List<String> get messages => List.unmodifiable(_messages);

  void log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    _messages.insert(0, '[$timestamp] $message');
    // Keep the list reasonably bounded to avoid memory growth during long runs
    if (_messages.length > 1000) _messages.removeRange(1000, _messages.length);
    notifyListeners();
  }

  void clear() {
    _messages.clear();
    notifyListeners();
  }
}
