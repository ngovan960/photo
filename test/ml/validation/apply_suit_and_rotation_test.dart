import 'dart:io';
import 'dart:math' show pi;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/editor/presentation/widgets/suit_painter.dart';

Future<ui.Image> decodeImageFromBytes(Uint8List bytes) async {
  final ui.Codec codec = await ui.instantiateImageCodec(bytes);
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  return frameInfo.image;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Posture Alignment & Formal Suit Overlay Integration Test', () {
    test('Generate office suit composites for test images', () async {
      final processedDir = Directory('img_test/processed_mobile');
      if (!processedDir.existsSync()) {
        print('Processed mobile images directory not found!');
        return;
      }

      final outputDir = Directory('img_test/suit_composites');
      if (!outputDir.existsSync()) {
        outputDir.createSync(recursive: true);
      }

      print('\n=== APPLYING ROTATION & OFFICE SUIT OVERLAYS (MOBILE PROCESSED) ===');

      // Final optimal configurations based on grid-search verification and new alignment math
      final configs = [
        {
          'filename': 'photo-2-1620561219170411338495_cccd_mobile.jpg',
          'suitType': SuitType.womenClassic,
          'rotation': 3.5,
          'scale': 1.05,
          'suitDx': 0.0,
          'suitDy': 0.0,
          'outputName': 'photo-2_female_classic.png',
        },
        {
          'filename': 'z407811279454704d3b10be2c47b86e5bd170832bde562-16753562253021567389777_cccd_mobile.jpg',
          'suitType': SuitType.menClassic,
          'rotation': -2.5,
          'scale': 1.20,
          'suitDx': 0.0,
          'suitDy': 15.0,
          'outputName': 'male_suited_classic.png',
        },
        {
          'filename': '0d4d9fd5c4b55455db3c6ad8057552bd_cccd_mobile.jpg',
          'suitType': SuitType.womenModern,
          'rotation': -4.5,
          'scale': 0.95,
          'suitDx': 0.0,
          'suitDy': 15.0,
          'outputName': 'female_suited_modern.png',
        }
      ];

      for (final config in configs) {
        final filename = config['filename'] as String;
        final file = File('${processedDir.path}/$filename');
        if (!file.existsSync()) {
          print('Skipping $filename (not found)');
          continue;
        }

        final bytes = file.readAsBytesSync();
        final portraitImage = await decodeImageFromBytes(bytes);
        final width = portraitImage.width;
        final height = portraitImage.height;

        // Wide grid search sweep to find perfect alignment
        final scales = [1.15, 1.20, 1.25, 1.30, 1.35, 1.40, 1.45, 1.50];
        final dyOffsets = [15.0, 30.0, 45.0, 60.0, 75.0, 90.0];

        for (final scale in scales) {
          for (final dy in dyOffsets) {
            final recorder = ui.PictureRecorder();
            final canvas = Canvas(recorder);

            final suitType = config['suitType'] as SuitType;
            final suitDx = config['suitDx'] as double;
            final rotation = config['rotation'] as double;

            // Preserve square 1:1 aspect ratio of the asset to prevent squishing
            final suitWidth = width * scale;
            final suitHeight = suitWidth; 
            
            final suitX = (width - suitWidth) / 2 + suitDx;
            
            // Align by collar percentage:
            // menClassic: 0.33, womenClassic: 0.46, womenModern: 0.71
            double collarAssetYPct = 0.33;
            if (suitType == SuitType.womenClassic) {
              collarAssetYPct = 0.46;
            } else if (suitType == SuitType.womenModern) {
              collarAssetYPct = 0.71;
            }
            
            // Align the collar to target neck line (height * 0.40 + dy offset)
            final collarTargetY = height * 0.40 + dy;
            final suitY = collarTargetY - (suitHeight * collarAssetYPct);

            // 1. Draw pure white background
            final bgPaint = Paint()..color = Colors.white;
            canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), bgPaint);

            // 2. Draw rotated original portrait (head alignment simulation)
            canvas.save();
            // Clip bottom 40px to hide hands while keeping neck/hair natural
            canvas.clipRect(Rect.fromLTWH(0, 0, width.toDouble(), height - 40.0));
            canvas.translate(width / 2, height / 2);
            final rotationAngleRadians = rotation * (pi / 180.0);
            canvas.rotate(rotationAngleRadians);
            canvas.translate(-width / 2, -height / 2);
            canvas.drawImage(portraitImage, Offset.zero, Paint());
            canvas.restore();

            // 3. Draw Suit Overlay
            String assetName;
            switch (suitType) {
              case SuitType.menClassic:
                assetName = 'men_classic.png';
                break;
              case SuitType.menModern:
                assetName = 'men_modern.png';
                break;
              case SuitType.womenClassic:
                assetName = 'women_classic.png';
                break;
              case SuitType.womenModern:
                assetName = 'women_modern.png';
                break;
              default:
                assetName = '';
            }

            if (assetName.isNotEmpty) {
              final suitFile = File('assets/images/$assetName');
              if (suitFile.existsSync()) {
                final suitBytes = suitFile.readAsBytesSync();
                final suitImage = await decodeImageFromBytes(suitBytes);

                canvas.save();
                canvas.drawImageRect(
                  suitImage,
                  Rect.fromLTWH(0, 0, suitImage.width.toDouble(), suitImage.height.toDouble()),
                  Rect.fromLTWH(suitX, suitY, suitWidth, suitHeight),
                  Paint()..isAntiAlias = true..filterQuality = ui.FilterQuality.high,
                );
                canvas.restore();
              }
            }

            // 4. Save to image file
            final picture = recorder.endRecording();
            final compositedImage = await picture.toImage(width, height);
            final byteData = await compositedImage.toByteData(format: ui.ImageByteFormat.png);
            
            if (byteData != null) {
              final outputBytes = byteData.buffer.asUint8List();
              final baseName = config['outputName'] as String;
              // Remove the .png extension from the baseName if present
              final cleanBaseName = baseName.replaceAll('.png', '');
              final outputFile = File('${outputDir.path}/${cleanBaseName}_s_${scale.toStringAsFixed(2)}_dy_${dy.toInt()}.png');
              outputFile.writeAsBytesSync(outputBytes);
            }
          }
        }
        print('Generated collar-aligned grid search sweep for $filename');
      }

      print('=== INTEGRATION TEST COMPLETE ===');
    });
  });
}
