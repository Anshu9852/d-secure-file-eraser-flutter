import 'package:flutter/material.dart';
 
// NEW: 4 theme modes instead of simple true/false dark toggle.
// light      -> original light theme
// dark       -> original dark theme
// greenLight -> NEW: light background with green tint (shield icon button)
// greenDark  -> NEW: dark background, all text greenish (flash icon button)
enum AppThemeMode { light, dark, greenLight, greenDark }
 
class AppColors {
  // Main Theme Accent (Teal / Green)
  static const Color primaryTeal = Color(0xFF0D9488);
  static const Color activeGreenBg = Color(0xFFDCFCE7);
  static const Color activeGreenText = Color(0xFF15803D);
 
  // Light Theme Colors
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightCard = Colors.white;
  static const Color lightText = Color(0xFF1E293B);
  static const Color lightGreyText = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);
 
  // Dark Theme Colors (Reference Photo #4)
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkText = Color(0xFFF8FAFC);
  static const Color darkGreyText = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);
 
  // ---- NEW: Light Greenish Theme (3rd Theme Mode button - shield icon) ----
  static const Color greenLightBg = Color(0xFFF0FDF4);
  static const Color greenLightCard = Color(0xFFFFFFFF);
  static const Color greenLightBorder = Color(0xFFBBF7D0);
  static const Color greenLightText = Color(0xFF14532D);
  static const Color greenLightGreyText = Color(0xFF4D7C5F);
 
  // ---- NEW: Dark Theme with Green Text (4th Theme Mode button - flash icon) ----
  static const Color greenDarkText = Color(0xFF4ADE80);
  static const Color greenDarkGreyText = Color(0xFF86EFAC);
}
 