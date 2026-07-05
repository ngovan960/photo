import 'package:flutter/material.dart';
import 'package:photo_id/core/theme/app_colors.dart';

class CaptureButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isCapturing;

  const CaptureButton({
    super.key,
    this.onPressed,
    this.isCapturing = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCapturing ? null : onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.white,
            width: 4,
          ),
        ),
        child: Center(
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCapturing ? AppColors.gray400 : AppColors.white,
            ),
            child: isCapturing
                ? const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.gray600,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
