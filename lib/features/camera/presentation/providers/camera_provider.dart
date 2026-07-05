import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/features/camera/domain/models/face_detection_result.dart';
import 'package:photo_id/features/camera/domain/repositories/camera_repository.dart';
import 'package:photo_id/features/camera/data/repositories/camera_repository_impl.dart';
import 'package:photo_id/ml/face_detection/face_detection_service.dart';
import 'package:photo_id/ml/face_detection/mlkit_face_detection.dart';

// Face detection service provider
final faceDetectionServiceProvider = Provider<FaceDetectionService>((ref) {
  return MLKitFaceDetectionService();
});

// Camera repository provider
final cameraRepositoryProvider = Provider<CameraRepository>((ref) {
  final faceDetectionService = ref.watch(faceDetectionServiceProvider);
  return CameraRepositoryImpl(faceDetectionService: faceDetectionService);
});

// Camera state
class CameraState {
  final bool isInitialized;
  final bool isFrontCamera;
  final bool isFlashOn;
  final Uint8List? capturedPhoto;
  final FaceDetectionResult? faceResult;
  final bool isCapturing;
  final String? error;

  const CameraState({
    this.isInitialized = false,
    this.isFrontCamera = true,
    this.isFlashOn = false,
    this.capturedPhoto,
    this.faceResult,
    this.isCapturing = false,
    this.error,
  });

  CameraState copyWith({
    bool? isInitialized,
    bool? isFrontCamera,
    bool? isFlashOn,
    Uint8List? capturedPhoto,
    FaceDetectionResult? faceResult,
    bool? isCapturing,
    String? error,
    bool clearPhoto = false,
    bool clearFace = false,
    bool clearError = false,
  }) {
    return CameraState(
      isInitialized: isInitialized ?? this.isInitialized,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      capturedPhoto: clearPhoto ? null : (capturedPhoto ?? this.capturedPhoto),
      faceResult: clearFace ? null : (faceResult ?? this.faceResult),
      isCapturing: isCapturing ?? this.isCapturing,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// Camera provider
class CameraNotifier extends StateNotifier<CameraState> {
  final CameraRepository _repository;

  CameraNotifier(this._repository) : super(const CameraState());

  Future<void> initialize() async {
    try {
      await _repository.initialize();
      state = state.copyWith(
        isInitialized: true,
        isFrontCamera: _repository.isFrontCamera,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> toggleFlash() async {
    await _repository.toggleFlash();
    state = state.copyWith(isFlashOn: !state.isFlashOn);
  }

  Future<void> switchCamera() async {
    await _repository.switchCamera();
    state = state.copyWith(
      isFrontCamera: _repository.isFrontCamera,
    );
  }

  Future<void> capturePhoto() async {
    if (state.isCapturing) return;

    state = state.copyWith(isCapturing: true, clearError: true);

    try {
      final photoBytes = await _repository.capturePhoto();
      if (photoBytes == null) {
        state = state.copyWith(
          isCapturing: false,
          error: 'Failed to capture photo',
        );
        return;
      }

      // Detect face
      final faceResult = await _repository.detectFace(photoBytes);

      state = state.copyWith(
        isCapturing: false,
        capturedPhoto: photoBytes,
        faceResult: faceResult,
      );
    } catch (e) {
      state = state.copyWith(
        isCapturing: false,
        error: e.toString(),
      );
    }
  }

  void clearPhoto() {
    state = state.copyWith(clearPhoto: true, clearFace: true);
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}

final cameraProvider = StateNotifierProvider<CameraNotifier, CameraState>((ref) {
  final repository = ref.watch(cameraRepositoryProvider);
  return CameraNotifier(repository);
});
