import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/features/camera/presentation/providers/camera_provider.dart';
import 'package:photo_id/features/editor/presentation/providers/editor_provider.dart';

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
  double _captureProgress = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cameraProvider.notifier).initialize();
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Listen for captured photo to navigate to editor
    ref.listen<CameraState>(cameraProvider, (previous, next) {
      if (next.capturedPhoto != null && previous?.capturedPhoto == null) {
        final countryCode = widget.documentId.split('_').first;
        ref.read(editorProvider.notifier).loadPhoto(
              next.capturedPhoto!,
              countryCode,
              widget.documentId,
            );
        final photoId = ref.read(editorProvider).photo?.id;
        if (photoId != null) {
          ref.read(cameraProvider.notifier).clearPhoto();
          context.pushReplacement('/editor/$photoId');
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Live Camera Feed Viewfinder
          if (cameraState.isInitialized && cameraState.controller != null)
            ClipRect(
              child: OverflowBox(
                alignment: Alignment.center,
                child: cameraState.controller!.value.isInitialized
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: cameraState.controller!.value.previewSize!.height,
                          height: cameraState.controller!.value.previewSize!.width,
                          child: CameraPreview(cameraState.controller!),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

          // 2. Viewfinder Semi-Transparent Mask (Radial Gradient equivalent overlay)
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),

          // 3. Face Oval Overlay Guide
          Center(
            child: IgnorePointer(
              child: Container(
                width: 280,
                height: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                  border: Border.all(
                    color: cameraState.faceResult?.isFrontal == true
                        ? const Color(0xFF4EDEA3)
                        : Colors.white30,
                    width: cameraState.faceResult?.isFrontal == true ? 3.0 : 2.0,
                  ),
                  boxShadow: cameraState.faceResult?.isFrontal == true
                      ? [
                          BoxShadow(
                            color: const Color(0xFF4EDEA3).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
              ),
            ),
          ),

          // 4. Top AppBar & Header Info
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    const Text(
                      'Position Face',
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        cameraState.isFlashOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                      ),
                      onPressed: () => ref.read(cameraProvider.notifier).toggleFlash(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 5. Instruction Status Chips & Texts
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF4EDEA3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Ideal Lighting',
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4EDEA3),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    cameraState.faceResult?.isFrontal == true
                        ? 'Hold still...'
                        : 'Position your face within the oval',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Hanken Grotesk',
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 6. Biometric Progress Bar (above controls)
          Positioned(
            bottom: 120,
            left: 24,
            right: 24,
            child: Column(
              children: [
                if (cameraState.isCapturing) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _captureProgress,
                      backgroundColor: Colors.white12,
                      color: const Color(0xFF4EDEA3),
                      minHeight: 4,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 7. Bottom Control Pit (Gallery, Capture Shutter, Switch Camera)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 24, top: 16),
              color: Colors.black.withOpacity(0.85),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Gallery access
                    IconButton(
                      icon: const Icon(Icons.photo_library, color: Colors.white70, size: 28),
                      onPressed: () => context.push('/gallery'),
                    ),

                    // Primary capture button
                    GestureDetector(
                      onTap: () async {
                        if (cameraState.isCapturing) return;
                        setState(() {
                          _captureProgress = 0.3;
                        });
                        await ref.read(cameraProvider.notifier).capturePhoto();
                        setState(() {
                          _captureProgress = 1.0;
                        });
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Switch camera
                    IconButton(
                      icon: const Icon(Icons.cached, color: Colors.white70, size: 28),
                      onPressed: () => ref.read(cameraProvider.notifier).switchCamera(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
