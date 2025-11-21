import 'dart:io';
import 'package:image/image.dart';

void main() {
  final Map<String, Color> colors = {
    'veggieDelight_footlong.png': ColorRgb8(76, 175, 80), // green
    'veggieDelight_six_inch.png': ColorRgb8(139, 195, 74),
    'chickenTeriyaki_footlong.png': ColorRgb8(255, 152, 0), // orange
    'chickenTeriyaki_six_inch.png': ColorRgb8(255, 193, 7),
    'tunaMelt_footlong.png': ColorRgb8(33, 150, 243), // blue
    'tunaMelt_six_inch.png': ColorRgb8(3, 169, 244),
    'meatballMarinara_footlong.png': ColorRgb8(244, 67, 54), // red
    'meatballMarinara_six_inch.png': ColorRgb8(239, 83, 80),
  };

  final dir = Directory('assets/images');
  if (!dir.existsSync()) dir.createSync(recursive: true);

  for (final entry in colors.entries) {
    final fileName = entry.key;
    final color = entry.value;
    final image = Image(
      width: 320,
      height: 200,
    ); // wider rectangle for the app's aspect
    fill(image, color: color);

    // Add a thin darker band at bottom so it looks like a banner
    fillRect(
      image,
      x1: 0,
      y1: 170,
      x2: 320,
      y2: 199,
      color: ColorRgba8(0, 0, 0, 60),
    );

    // For veggieDelight images, draw a simple 'bread + veggies' icon and label
    if (fileName.startsWith('veggieDelight')) {
      // Draw a rounded rectangle to represent the bread (simple filled rect)
      fillRect(
        image,
        x1: 60,
        y1: 90,
        x2: 260,
        y2: 150,
        color: ColorRgb8(244, 214, 175),
      );
      // Add a darker crust band
      fillRect(
        image,
        x1: 60,
        y1: 86,
        x2: 260,
        y2: 94,
        color: ColorRgb8(210, 150, 80),
      );
      // Add some green 'lettuce' circles
      fillCircle(
        image,
        x: 100,
        y: 110,
        radius: 10,
        color: ColorRgb8(76, 175, 80),
      );
      fillCircle(
        image,
        x: 140,
        y: 115,
        radius: 10,
        color: ColorRgb8(56, 142, 60),
      );
      fillCircle(
        image,
        x: 180,
        y: 110,
        radius: 10,
        color: ColorRgb8(76, 175, 80),
      );
      // Draw the label (string then named font)
      drawString(
        image,
        'Veggie Delight',
        font: arial24,
        x: 12,
        y: 8,
        color: ColorRgb8(255, 255, 255),
      );
      drawString(
        image,
        'on white bread',
        font: arial24,
        x: 12,
        y: 34,
        color: ColorRgb8(255, 255, 255),
      );
    }

    final png = encodePng(image, level: 6);
    final file = File('assets/images/$fileName');
    file.writeAsBytesSync(png);
    print('Wrote ${file.path} (${png.length} bytes)');
  }

  print('Generated colored placeholders.');
}
