import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:photo_id/features/camera/domain/models/face_detection_result.dart';
import 'package:photo_id/features/camera/domain/repositories/camera_repository.dart';
import 'package:photo_id/ml/face_detection/face_detection_service.dart';

class CameraRepositoryImpl implements CameraRepository {
  CameraController? _controller;
  final FaceDetectionService _faceDetectionService;
  List<CameraDescription> _cameras = [];
  int _currentCameraIndex = 0;
  bool _isInitialized = false;

  CameraRepositoryImpl({
    required FaceDetectionService faceDetectionService,
  }) : _faceDetectionService = faceDetectionService;

  @override
  bool get isInitialized => _isInitialized;

  @override
  bool get isFrontCamera =>
      _cameras.isNotEmpty &&
      _cameras[_currentCameraIndex].lensDirection == CameraLensDirection.front;

  @override
  Future<void> initialize() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) {
      throw Exception('No cameras available');
    }

    _controller = CameraController(
      _cameras[_currentCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    _isInitialized = true;
  }

  @override
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }

  @override
  Future<void> toggleFlash() async {
    if (_controller == null) return;

    final currentMode = _controller!.value.flashMode;
    final newMode = currentMode == FlashMode.auto
        ? FlashMode.always
        : currentMode == FlashMode.always
            ? FlashMode.off
            : FlashMode.auto;

    await _controller!.setFlashMode(newMode);
  }

  @override
  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;

    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;

    await _controller?.dispose();
    _controller = CameraController(
      _cameras[_currentCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
  }

  @override
  Future<Uint8List?> capturePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return null;

    final XFile file = await _controller!.takePicture();
    return await file.readAsBytes();
  }

  @override
  Future<FaceDetectionResult?> detectFace(Uint8List imageBytes) async {
    return await _faceDetectionService.detectFace(imageBytes);
  }

  CameraController? get controller => _controller;
}
