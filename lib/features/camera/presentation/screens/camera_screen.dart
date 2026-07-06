import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/features/camera/presentation/providers/camera_provider.dart';
import 'package:photo_id/features/camera/presentation/widgets/guide_overlay.dart';
import 'package:photo_id/features/camera/presentation/widgets/capture_button.dart';
import 'package:photo_id/features/camera/presentation/widgets/tips_panel.dart';

class CameraScreen extends ConsumerStatefulWidget {
  final String documentId;

  const CameraScreen({
    super.key,
    required this.documentId,
  });

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cameraProvider.notifier).initialize();
      // Start realtime face detection
      ref.read(cameraProvider.notifier).startFrameProcessing();
    });
  }

  @override
  void dispose() {
    ref.read(cameraProvider.notifier).stopFrameProcessing();
    ref.read(cameraProvider.notifier).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraProvider);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, cameraState),
            // Camera preview
            Expanded(
              child: _buildCameraPreview(cameraState),
            ),
            // Tips panel
            const TipsPanel(),
            // Controls
            _buildControls(cameraState),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CameraState state) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Text(
              widget.documentId.toUpperCase(),
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: Icon(
              state.isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: AppColors.white,
            ),
            onPressed: () => ref.read(cameraProvider.notifier).toggleFlash(),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview(CameraState state) {
    if (!state.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.white),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: AppSpacing.sm),
            Text(
              state.error!,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Real camera preview
        if (state.controller != null)
          ClipRect(
            child: OverflowBox(
              alignment: Alignment.center,
              child: state.controller!.value.isInitialized
                  ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: state.controller!.value.previewSize!.height,
                        height: state.controller!.value.previewSize!.width,
                        child: CameraPreview(state.controller!),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        // Guide overlay
        const GuideOverlay(),
        // Face detection indicator
        if (state.faceResult != null)
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: state.faceResult!.isFrontal
                    ? AppColors.success
                    : AppColors.warning,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                state.faceResult!.isFrontal ? 'Face OK' : 'Adjust',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildControls(CameraState state) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gallery button
          IconButton(
            icon: const Icon(Icons.photo_library, color: AppColors.white),
            onPressed: () => context.push('/gallery'),
          ),
          // Capture button
          CaptureButton(
            onPressed: () => ref.read(cameraProvider.notifier).capturePhoto(),
            isCapturing: state.isCapturing,
          ),
          // Switch camera button
          IconButton(
            icon: const Icon(Icons.cameraswitch, color: AppColors.white),
            onPressed: () => ref.read(cameraProvider.notifier).switchCamera(),
          ),
        ],
      ),
    );
  }
}
