// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

extension ImageX on img.Image {
  bool isEqualColor(img.Image other) {
    if (other.width != width) return false;
    if (other.height != height) return false;
    bool isEqual = true;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = getPixel(x, y);
        final otherPixel = other.getPixel(x, y);
        if (pixel.r != otherPixel.r ||
            pixel.g != otherPixel.g ||
            pixel.b != otherPixel.b) {
          isEqual = false;
        }
      }
    }
    return isEqual;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? file;
  int count = 0;

  Future<File> loadImageAndRemoveBackground() async {
    // Load the image from assets
    ByteData data = await rootBundle.load('assets/Group 1.png');
    Uint8List bytes = data.buffer.asUint8List();

    // Decode the image
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception("Failed to decode image");
    }
    final copy = image.clone();

    print('Before ${image.isEqualColor(copy)}');

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        if (pixel.r == 255 && pixel.g == 255 && pixel.b == 255) {
          image.setPixel(x, y, img.ColorInt8.rgb(217, 217, 217));
        }
      }
    }

    print('After ${image.isEqualColor(copy)}');

    final file = File('output$count.png');
    await file.writeAsBytes(img.encodePng(image));
    return file;
  }

  @override
  Widget build(BuildContext context) {
    print('Rebuilding');
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: TextButton(
            child: const Text('Remove Background'),
            onPressed: () async {
              final f = await loadImageAndRemoveBackground();
              setState(() {
                count++;
                file = f;
              });
            },
          ),
        ),
        body: Row(
          children: [
            Column(
              children: [
                const Text('Before'),
                Center(child: Image.asset('assets/Group 1.png')),
              ],
            ),
            Column(
              children: [
                const Text('After'),
                Center(
                  child: file != null
                      ? Image.file(file!)
                      : const Text('No image selected'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
