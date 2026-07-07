import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/features/editor/domain/models/photo_model.dart';
import 'package:photo_id/features/editor/domain/models/background_color.dart';
import 'package:photo_id/features/editor/domain/models/validation_result.dart';
import 'package:photo_id/features/editor/domain/repositories/editor_repository.dart';
import 'package:photo_id/features/editor/data/repositories/editor_repository_impl.dart';
import 'package:photo_id/ml/background_removal/background_removal_service.dart';
import 'package:photo_id/ml/background_removal/media_pipe_bg_removal.dart';
import 'package:photo_id/ml/validation/photo_validator.dart';
import 'package:photo_id/features/countries/domain/models/country_model.dart';

// Services
final bgRemovalServiceProvider = Provider<BackgroundRemovalService>((ref) {
  return MediaPipeBackgroundRemovalService();
});

final photoValidatorProvider = Provider<PhotoValidator>((ref) {
  return PhotoValidator();
});

// Repository
final editorRepositoryProvider = Provider<EditorRepository>((ref) {
  return EditorRepositoryImpl(
    bgRemovalService: ref.watch(bgRemovalServiceProvider),
    validator: ref.watch(photoValidatorProvider),
  );
});

// Editor state
class EditorState {
  final Photo? photo;
  final BackgroundColor selectedBackground;
  final ValidationResult? validationResult;
  final bool isProcessing;
  final String? error;

  // Custom alignment and suit fields
  final double rotationAngle;
  final String selectedSuit; // 'none', 'men_classic', 'men_modern', 'women_classic', 'women_modern'
  final double suitDx;
  final double suitDy;
  final double suitScale;

  const EditorState({
    this.photo,
    this.selectedBackground = BackgroundColor.white,
    this.validationResult,
    this.isProcessing = false,
    this.error,
    this.rotationAngle = 0.0,
    this.selectedSuit = 'none',
    this.suitDx = 0.0,
    this.suitDy = 0.0,
    this.suitScale = 1.0,
  });

  EditorState copyWith({
    Photo? photo,
    BackgroundColor? selectedBackground,
    ValidationResult? validationResult,
    bool? isProcessing,
    String? error,
    double? rotationAngle,
    String? selectedSuit,
    double? suitDx,
    double? suitDy,
    double? suitScale,
    bool clearPhoto = false,
    bool clearValidation = false,
    bool clearError = false,
  }) {
    return EditorState(
      photo: clearPhoto ? null : (photo ?? this.photo),
      selectedBackground: selectedBackground ?? this.selectedBackground,
      validationResult: clearValidation
          ? null
          : (validationResult ?? this.validationResult),
      isProcessing: isProcessing ?? this.isProcessing,
      error: clearError ? null : (error ?? this.error),
      rotationAngle: rotationAngle ?? this.rotationAngle,
      selectedSuit: selectedSuit ?? this.selectedSuit,
      suitDx: suitDx ?? this.suitDx,
      suitDy: suitDy ?? this.suitDy,
      suitScale: suitScale ?? this.suitScale,
    );
  }
}

// Editor provider
class EditorNotifier extends StateNotifier<EditorState> {
  final EditorRepository _repository;

  EditorNotifier(this._repository) : super(const EditorState());

  void loadPhoto(Uint8List imageBytes, String countryCode, String documentId) {
    final photo = Photo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      countryCode: countryCode,
      documentId: documentId,
      createdAt: DateTime.now(),
      originalBytes: imageBytes,
    );
    state = state.copyWith(
      photo: photo,
      rotationAngle: 0.0,
      selectedSuit: 'none',
      suitDx: 0.0,
      suitDy: 0.0,
      suitScale: 1.0,
      clearError: true,
    );
  }

  void setRotationAngle(double angle) {
    state = state.copyWith(rotationAngle: angle);
  }

  void selectSuit(String suit) {
    state = state.copyWith(
      selectedSuit: suit,
      suitDx: 0.0,
      suitDy: 0.0,
      suitScale: 1.0,
    );
  }

  void updateSuitPosition(double dx, double dy) {
    state = state.copyWith(suitDx: dx, suitDy: dy);
  }

  void updateSuitScale(double scale) {
    state = state.copyWith(suitScale: scale);
  }

  void setProcessedBytes(Uint8List bytes) {
    if (state.photo == null) return;
    state = state.copyWith(
      photo: state.photo!.copyWith(processedBytes: bytes),
    );
  }

  Future<void> removeBackground() async {
    if (state.photo == null || state.isProcessing) return;

    state = state.copyWith(isProcessing: true, clearError: true);

    try {
      final originalBytes = state.photo!.originalBytes;
      if (originalBytes == null) throw Exception('No original photo');

      final processedBytes = await _repository.removeBackground(originalBytes);

      state = state.copyWith(
        isProcessing: false,
        photo: state.photo!.copyWith(processedBytes: processedBytes),
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }

  Future<void> changeBackground(BackgroundColor color) async {
    if (state.photo == null || state.isProcessing) return;

    state = state.copyWith(
      isProcessing: true,
      selectedBackground: color,
      clearError: true,
    );

    try {
      final imageBytes = state.photo!.processedBytes ?? state.photo!.originalBytes;
      if (imageBytes == null) throw Exception('No image to process');

      final processedBytes = await _repository.changeBackground(imageBytes, color);

      state = state.copyWith(
        isProcessing: false,
        photo: state.photo!.copyWith(processedBytes: processedBytes),
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }

  Future<void> cropAndResize(double widthMm, double heightMm) async {
    if (state.photo == null || state.isProcessing) return;

    state = state.copyWith(isProcessing: true, clearError: true);

    try {
      final imageBytes = state.photo!.processedBytes ?? state.photo!.originalBytes;
      if (imageBytes == null) throw Exception('No image to process');

      final croppedBytes = await _repository.cropAndResize(imageBytes, widthMm, heightMm);

      state = state.copyWith(
        isProcessing: false,
        photo: state.photo!.copyWith(processedBytes: croppedBytes),
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }

  void validatePhoto(Document documentSpec) {
    if (state.photo == null) return;

    final imageBytes = state.photo!.processedBytes ?? state.photo!.originalBytes;
    if (imageBytes == null) return;

    final result = _repository.validatePhoto(
      imageBytes: imageBytes,
      documentSpec: documentSpec,
    );

    state = state.copyWith(
      validationResult: result,
      photo: state.photo!.copyWith(
        qualityScore: result.score,
        validationResults: {
          'face_size': result.faceSizeOk,
          'background': result.backgroundOk,
          'lighting': result.lightingOk,
          'expression': result.expressionOk,
          'sharpness': result.sharpnessOk,
          'shadow': result.shadowFree,
        },
      ),
    );
  }

  void clearPhoto() {
    state = state.copyWith(clearPhoto: true, clearValidation: true);
  }
}

final editorProvider = StateNotifierProvider<EditorNotifier, EditorState>((ref) {
  final repository = ref.watch(editorRepositoryProvider);
  return EditorNotifier(repository);
});
