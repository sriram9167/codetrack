import 'package:material_ui/material_ui.dart';

abstract final class AppColors {
  static const background = Color(0xFF0B1220);
  static const surface = Color(0xFF111C2E);
  static const card = Color(0xFF16233A);
  static const border = Color(0xFF23334D);
  static const primary = Color(0xFF6366F1);
  static const cyan = Color(0xFF22D3EE);
  static const green = Color(0xFF34D399);
  static const amber = Color(0xFFFBBF24);
  static const red = Color(0xFFF87171);
  static const textPrimary = Color(0xFFE2E8F0);
  static const textMuted = Color(0xFF94A3B8);
}

ThemeData buildTheme() {
  const outline = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: AppColors.border),
  );

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.cyan,
      surface: AppColors.surface,
      error: AppColors.red,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: false,
      foregroundColor: AppColors.textPrimary,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        side: BorderSide(color: AppColors.border),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      height: 68,
      indicatorColor: AppColors.primary.withValues(alpha: 0.22),
      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.card,
      border: outline,
      enabledBorder: outline,
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.primary, width: 1.6),
      ),
      labelStyle: const TextStyle(color: AppColors.textMuted),
      hintStyle: const TextStyle(color: AppColors.textMuted),
    ),
    dividerColor: AppColors.border,
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.card,
      contentTextStyle: TextStyle(color: AppColors.textPrimary),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      linearTrackColor: AppColors.border,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(color: AppColors.textPrimary),
      bodySmall: TextStyle(color: AppColors.textMuted),
      labelMedium: TextStyle(color: AppColors.textMuted),
    ),
  );
}

Color scoreColor(double score) {
  if (score >= 8) return AppColors.green;
  if (score >= 6) return AppColors.cyan;
  if (score >= 5) return AppColors.amber;
  return AppColors.red;
}
