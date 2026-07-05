import 'package:flutter/material.dart';

enum BackgroundColor {
  white,
  blue,
  red,
  gray;

  Color get color {
    switch (this) {
      case BackgroundColor.white:
        return const Color(0xFFFFFFFF);
      case BackgroundColor.blue:
        return const Color(0xFF4DA8DA);
      case BackgroundColor.red:
        return const Color(0xFFDC3545);
      case BackgroundColor.gray:
        return const Color(0xFFB0BEC5);
    }
  }

  String get label {
    switch (this) {
      case BackgroundColor.white:
        return 'Trắng';
      case BackgroundColor.blue:
        return 'Xanh';
      case BackgroundColor.red:
        return 'Đỏ';
      case BackgroundColor.gray:
        return 'Xám';
    }
  }

  String get hex {
    switch (this) {
      case BackgroundColor.white:
        return '#FFFFFF';
      case BackgroundColor.blue:
        return '#4DA8DA';
      case BackgroundColor.red:
        return '#DC3545';
      case BackgroundColor.gray:
        return '#B0BEC5';
    }
  }
}
