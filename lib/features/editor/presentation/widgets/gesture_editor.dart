import 'dart:math' show pi;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_id/features/editor/domain/models/outfit_template.dart';

class GestureEditor extends StatefulWidget {
  final OutfitTemplate outfit;
  final Uint8List? photoBytes;
  final Color backgroundColor;
  final ValueChanged<OutfitTransform> onTransformChanged;
  final VoidCallback? onConfirm;

  const GestureEditor({
    super.key,
    required this.outfit,
    this.photoBytes,
    this.backgroundColor = Colors.white,
    required this.onTransformChanged,
    this.onConfirm,
  });

  @override
  State<GestureEditor> createState() => _GestureEditorState();
}

class OutfitTransform {
  final Offset position;
  final double scale;
  final double rotation;

  const OutfitTransform({
    this.position = Offset.zero,
    this.scale = 1.0,
    this.rotation = 0.0,
  });

  OutfitTransform copyWith({
    Offset? position,
    double? scale,
    double? rotation,
  }) {
    return OutfitTransform(
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
    );
  }
}

class _GestureEditorState extends State<GestureEditor> {
  late OutfitTransform _transform;
  double _baseScale = 1.0;
  double _baseRotation = 0.0;
  Offset _basePosition = Offset.zero;
  Offset _lastFocalPoint = Offset.zero;

  @override
  void initState() {
    super.initState();
    _transform = OutfitTransform(
      position: widget.outfit.defaultPosition,
      scale: widget.outfit.defaultScale,
      rotation: 0.0,
    );
  }

  @override
  void didUpdateWidget(GestureEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.outfit.id != widget.outfit.id) {
      _transform = OutfitTransform(
        position: widget.outfit.defaultPosition,
        scale: widget.outfit.defaultScale,
        rotation: 0.0,
      );
      _notifyTransformChanged();
    }
  }

  void _notifyTransformChanged() {
    widget.onTransformChanged(_transform);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? const Color(0xFF131B2E) : Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: widget.backgroundColor,
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    if (widget.photoBytes != null && widget.photoBytes!.isNotEmpty)
                      Image.memory(
                        widget.photoBytes!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                      ),

                    Positioned(
                      child: GestureDetector(
                        onScaleStart: _onScaleStart,
                        onScaleUpdate: _onScaleUpdate,
                        child: Transform(
                          transform: Matrix4.identity()
                            ..translate(_transform.position.dx, _transform.position.dy)
                            ..rotateZ(_transform.rotation * pi / 180)
                            ..scale(_transform.scale),
                          alignment: Alignment.center,
                          child: widget.outfit.imageBytes.isNotEmpty
                              ? Image.memory(
                                  widget.outfit.imageBytes,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.checkroom, size: 80),
                                )
                              : const Icon(Icons.checkroom, size: 80),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1D2438) : const Color(0xFFF3F3F8),
              border: Border(
                top: BorderSide(
                  color: isDark ? const Color(0xFF333D55) : const Color(0xFFE2E7FF),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildControlRow(
                  label: 'Kích thước',
                  value: '${_transform.scale.toStringAsFixed(2)}x',
                  min: 0.3,
                  max: 3.0,
                  value_: _transform.scale,
                  isDark: isDark,
                  onChanged: (val) {
                    setState(() {
                      _transform = _transform.copyWith(scale: val);
                    });
                    _notifyTransformChanged();
                  },
                ),
                const SizedBox(height: 8),
                _buildControlRow(
                  label: 'Xoay',
                  value: '${_transform.rotation.toStringAsFixed(1)}°',
                  min: -180.0,
                  max: 180.0,
                  value_: _transform.rotation,
                  isDark: isDark,
                  onChanged: (val) {
                    setState(() {
                      _transform = _transform.copyWith(rotation: val);
                    });
                    _notifyTransformChanged();
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: _resetTransform,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Đặt lại'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: widget.onConfirm,
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Xác nhận'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004AC6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlRow({
    required String label,
    required String value,
    required double min,
    required double max,
    required double value_,
    required bool isDark,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: isDark ? Colors.white70 : const Color(0xFF414755),
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: value_.clamp(min, max),
            min: min,
            max: max,
            activeColor: const Color(0xFF004AC6),
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 56,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004AC6),
            ),
          ),
        ),
      ],
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    _baseScale = _transform.scale;
    _baseRotation = _transform.rotation;
    _basePosition = _transform.position;
    _lastFocalPoint = details.focalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final dx = details.focalPoint.dx - _lastFocalPoint.dx;
    final dy = details.focalPoint.dy - _lastFocalPoint.dy;

    setState(() {
      _transform = _transform.copyWith(
        scale: (_baseScale * details.scale).clamp(0.3, 3.0),
        rotation: _baseRotation + (details.rotation * 180 / pi),
        position: _basePosition + Offset(dx, dy),
      );
    });
    _notifyTransformChanged();
  }

  void _resetTransform() {
    setState(() {
      _transform = OutfitTransform(
        position: widget.outfit.defaultPosition,
        scale: widget.outfit.defaultScale,
        rotation: 0.0,
      );
    });
    _notifyTransformChanged();
  }
}
