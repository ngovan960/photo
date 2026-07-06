import 'package:flutter/services.dart';

class HapticService {
  // Light impact - button tap
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  // Medium impact - important action
  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  // Heavy impact - error, success
  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  // Selection click
  static void selectionClick() {
    HapticFeedback.selectionClick();
  }

  // App-specific haptics
  static void onPhotoCaptured() {
    mediumImpact();
  }

  static void onFaceDetected() {
    selectionClick();
  }

  static void onValidationPass() {
    lightImpact();
  }

  static void onValidationFail() {
    heavyImpact();
  }

  static void onExportSuccess() {
    mediumImpact();
  }

  static void onError() {
    heavyImpact();
  }

  static void onButtonTap() {
    lightImpact();
  }

  static void onToggle() {
    selectionClick();
  }
}
