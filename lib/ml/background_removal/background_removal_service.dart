import 'dart:typed_data';
import 'package:photo_id/features/editor/domain/models/background_color.dart';

abstract class BackgroundRemovalService {
  Future<Uint8List> removeBackground(Uint8List imageBytes);
  Future<Uint8List> changeBackground(Uint8List imageBytes, BackgroundColor color);
}
