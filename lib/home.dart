// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_manipulator/painter.dart';
import 'package:image_manipulator/preview.dart';
import 'package:screenshot/screenshot.dart';

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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Offset> points = [];
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          child: const Text('Remove Background'),
          onPressed: () async {
            // final f = await loadImageAndRemoveBackground();
            // setState(() {
            //   count++;
            //   file = f;
            // });
          },
        ),
        actions: [
          ElevatedButton(
            child: const Text(
              'Capture Above Widget',
            ),
            onPressed: () {
              screenshotController
                  .capture(delay: const Duration(milliseconds: 10))
                  .then((capturedImage) async {
                print(capturedImage);
                ShowCapturedWidget(context, capturedImage!);
              }).catchError((onError) {
                print(onError);
              });
            },
          ),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Listener(
          onPointerDown: (e) {
            setState(() {
              points.add(e.localPosition);
            });
          },
          onPointerMove: (e) {
            setState(() {
              points.add(e.localPosition);
            });
          },
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/benz.png',
                ),
              ),
            ),
            child: CustomPaint(
              painter: DrawPainter(points),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> ShowCapturedWidget(
    BuildContext context,
    Uint8List capturedImage,
  ) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Preview(bytes: capturedImage),
    );
  }
}
