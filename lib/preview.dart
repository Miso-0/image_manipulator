// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:image_manipulator/home.dart';

class Preview extends StatefulWidget {
  const Preview({super.key, required this.bytes});
  final Uint8List bytes;

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  File? file;
  int count = 0;

  Future<File> loadImageAndRemoveBackground(Uint8List bytes) async {
    // // Load the image from assets
    // ByteData data = await rootBundle.load('assets/Group 1.png');
    // Uint8List bytes = data.buffer.asUint8List();

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
        if (pixel.r == 244 && pixel.g == 67 && pixel.b == 54) {
          image.setPixel(x, y, img.ColorInt8.rgb(0, 0, 0));
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
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text("Captured widget screenshot"),
      ),
      body: FutureBuilder<File?>(
        future: loadImageAndRemoveBackground(widget.bytes),
        builder: (context, snap) {
          if (snap.data != null) {
            return Center(child: Image.file(snap.data!));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
