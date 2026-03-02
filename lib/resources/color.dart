import 'dart:ui';

abstract final class AppColors {
  // Base
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const red = Color(0xFFEF5350);

  // Legacy (kept for compatibility)
  static const primary = Color(0xFF1B2B6B);
  static const darkGrey = Color(0xFF555555);
  static const lightGrey = Color(0xFFd5d5d5);
  static const greyText = Color(0xFF747474);
  static const blue = Color(0xFF2295F3);

  // Dark background gradients
  static const bgDark = Color(0xFF0B1437);
  static const bgMid = Color(0xFF1B2B6B);
  static const bgNight = Color(0xFF2D1B69);
  static const bgDay = Color(0xFF2E4A9A);

  // Accent
  static const accent = Color(0xFF64D9FB);
  static const tempColor = Color(0xFFFFD166);

  // Glass card
  static const glass = Color(0x1AFFFFFF);
  static const glassBorder = Color(0x33FFFFFF);
  static const glassDark = Color(0x26000000);

  // AQI colors
  static const aqiGood = Color(0xFF4CAF50);
  static const aqiModerate = Color(0xFFFFEB3B);
  static const aqiUnhealthy = Color(0xFFF44336);

  // Day gradient
  static const List<Color> dayGradient = [Color(0xFF2E6BE6), Color(0xFF1B2B6B)];
  // Night gradient
  static const List<Color> nightGradient = [Color(0xFF2D1B69), Color(0xFF0B1437)];
}
