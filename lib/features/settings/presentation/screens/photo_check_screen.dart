import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/ml/validation/photo_validator.dart';
import 'package:photo_id/features/editor/domain/models/validation_result.dart';
import 'package:photo_id/features/countries/domain/models/country_model.dart';

class PhotoCheckScreen extends ConsumerStatefulWidget {
  final Uint8List? imageBytes;

  const PhotoCheckScreen({
    super.key,
    this.imageBytes,
  });

  @override
  ConsumerState<PhotoCheckScreen> createState() => _PhotoCheckScreenState();
}

class _PhotoCheckScreenState extends ConsumerState<PhotoCheckScreen> {
  Uint8List? _imageBytes;
  ValidationResult? _validationResult;
  bool _isValidating = false;

  final Document _defaultDocSpec = const Document(
    id: 'standard_passport',
    name: 'Standard Passport',
    widthMm: 35,
    heightMm: 45,
    allowedBackgrounds: ['white', 'light_blue'],
    requirements: [
      'Face centered',
      'Even lighting',
      'Neutral expression',
    ],
    faceRatio: FaceRatioSpec(min: 0.5, max: 0.7, minEye: 0.5, maxEye: 0.7),
  );

  @override
  void initState() {
    super.initState();
    if (widget.imageBytes != null) {
      _imageBytes = widget.imageBytes;
      _runValidation();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      _runValidation();
    }
  }

  void _runValidation() {
    if (_imageBytes == null) return;
    setState(() {
      _isValidating = true;
    });

    try {
      final validator = PhotoValidator();
      final result = validator.validate(
        imageBytes: _imageBytes!,
        documentSpec: _defaultDocSpec,
        faceRatio: 0.6, // Default reasonable face ratio
        isFrontal: true,
      );
      setState(() {
        _validationResult = result;
        _isValidating = false;
      });
    } catch (e) {
      setState(() {
        _isValidating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF131B2E) : const Color(0xFFFAF8FF);
    final cardColor = isDark ? const Color(0xFF1D2438) : Colors.white;
    final dividerColor = isDark ? const Color(0xFF333D55) : const Color(0xFFE2E7FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF131B2E) : const Color(0xFFFAF8FF),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF004AC6),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Photo Results',
          style: TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF004AC6),
          ),
        ),
      ),
      body: _imageBytes == null
          ? _buildSelectPhotoState(isDark)
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo Preview with overlay guidelines and Quality Score Gauge
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: dividerColor.withOpacity(0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(
                              _imageBytes!,
                              fit: BoxFit.cover,
                            ),
                            // Guidelines Overlay
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 200,
                                  height: 270,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.4),
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(120),
                                  ),
                                ),
                              ),
                            ),
                            // Quality Score Gauge
                            if (_validationResult != null)
                              Positioned(
                                bottom: 16,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    width: 64,
                                    height: 64,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value: _validationResult!.score / 100,
                                          backgroundColor: Colors.grey.shade200,
                                          color: const Color(0xFF004AC6),
                                          strokeWidth: 4,
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${_validationResult!.score}',
                                              style: const TextStyle(
                                                fontFamily: 'Hanken Grotesk',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF131B2E),
                                              ),
                                            ),
                                            const Text(
                                              '/100',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 8,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Validation Results list
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Validation Results',
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_validationResult != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _validationResult!.allPassed
                                ? const Color(0xFFE2FBE7)
                                : const Color(0xFFFFF4E5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _validationResult!.allPassed ? 'Passed' : 'Pending Fixes',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _validationResult!.allPassed
                                  ? const Color(0xFF0A7C2B)
                                  : const Color(0xFFB25E00),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (_validationResult != null)
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: dividerColor.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          _buildValidationRow(
                            label: 'Face Position',
                            passed: _validationResult!.faceSizeOk,
                            isDark: isDark,
                          ),
                          Divider(height: 1, color: dividerColor),
                          _buildValidationRow(
                            label: 'Lighting Quality',
                            passed: _validationResult!.lightingOk,
                            detail: _validationResult!.lightingOk
                                ? null
                                : 'Slightly uneven lighting',
                            isDark: isDark,
                          ),
                          Divider(height: 1, color: dividerColor),
                          _buildValidationRow(
                            label: 'Background',
                            passed: _validationResult!.backgroundOk,
                            isDark: isDark,
                          ),
                          Divider(height: 1, color: dividerColor),
                          _buildValidationRow(
                            label: 'Eyes Visible',
                            passed: _validationResult!.expressionOk,
                            isDark: isDark,
                          ),
                          Divider(height: 1, color: dividerColor),
                          _buildValidationRow(
                            label: 'Neutral Expression',
                            passed: _validationResult!.expressionOk,
                            detail: _validationResult!.expressionOk
                                ? null
                                : 'Slight smile detected',
                            isDark: isDark,
                          ),
                          Divider(height: 1, color: dividerColor),
                          _buildValidationRow(
                            label: 'Sharpness',
                            passed: _validationResult!.sharpnessOk,
                            isDark: isDark,
                          ),
                          Divider(height: 1, color: dividerColor),
                          _buildValidationRow(
                            label: 'No Shadows',
                            passed: _validationResult!.shadowFree,
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Suggestions Card
                  if (_validationResult != null && _validationResult!.suggestions.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF004AC6).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF004AC6).withOpacity(0.15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.lightbulb,
                                color: Color(0xFF004AC6),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Suggestions for Improvement',
                                style: TextStyle(
                                  fontFamily: 'Hanken Grotesk',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF004AC6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._validationResult!.suggestions.map(
                            (suggestion) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.only(top: 6),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF004AC6),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      suggestion,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
      bottomNavigationBar: _imageBytes == null
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF131B2E) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retake Photo'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: dividerColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to Editor with default specifications
                            context.push('/countries');
                          },
                          icon: const Icon(Icons.print),
                          label: const Text('Export & Print'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004AC6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSelectPhotoState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 80,
              color: isDark ? Colors.white30 : Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Photo Selected',
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select a photo from your gallery to inspect alignment, lighting and compliance checks.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004AC6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Choose Photo',
                  style: TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationRow({
    required String label,
    required bool passed,
    String? detail,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: passed
                  ? const Color(0xFFE2FBE7)
                  : const Color(0xFFFFF4E5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              passed ? Icons.check_circle : Icons.warning,
              color: passed ? const Color(0xFF0A7C2B) : const Color(0xFFB25E00),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (detail != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            passed ? Icons.chevron_right : Icons.info_outline,
            color: Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }
}
