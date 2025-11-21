import 'dart:convert';
import 'dart:io';

void main() async {
  final base64Pixel =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=';

  final Map<String, String> files = {
    'assets/images/veggieDelight_footlong.png': base64Pixel,
    'assets/images/veggieDelight_six_inch.png': base64Pixel,
    'assets/images/chickenTeriyaki_footlong.png': base64Pixel,
    'assets/images/chickenTeriyaki_six_inch.png': base64Pixel,
    'assets/images/tunaMelt_footlong.png': base64Pixel,
    'assets/images/tunaMelt_six_inch.png': base64Pixel,
    'assets/images/meatballMarinara_footlong.png': base64Pixel,
    'assets/images/meatballMarinara_six_inch.png': base64Pixel,
  };

  for (final entry in files.entries) {
    final path = entry.key;
    final b64 = entry.value;
    final bytes = base64Decode(b64);
    final file = File(path);
    await file.create(recursive: true);
    await file.writeAsBytes(bytes);
    print('Wrote $path (${bytes.length} bytes)');
  }

  print('All placeholder images generated.');
}
