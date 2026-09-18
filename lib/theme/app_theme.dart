import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class AppColors {
  static const background = Color(0xFFF3F8FA);
  static const surface = Colors.white;
  static const primary = Color(0xFF087F75);
  static const primarySoft = Color(0xFFDDF4EB);
  static const ink = Color(0xFF172F3B);
  static const muted = Color(0xFF566D78);
  static const border = Color(0xFFDCE8EB);
  static const lavender = Color(0xFFEEEAFE);
}

abstract final class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.light, surface: AppColors.surface).copyWith(primary: AppColors.primary),
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: ThemeData.light().textTheme.apply(bodyColor: AppColors.ink, displayColor: AppColors.ink),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.ink,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.82),
      contentPadding: const EdgeInsets.all(17),
      labelStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
    ),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      minimumSize: const Size(48, 54),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
      minimumSize: const Size(48, 50),
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    )),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white.withValues(alpha: 0.75),
      selectedColor: AppColors.primarySoft,
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.ink,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerColor: AppColors.border,
  );
}
