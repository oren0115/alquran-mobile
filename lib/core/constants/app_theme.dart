import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.emerald,
          onPrimary: AppColors.emeraldLight,
          primaryContainer: AppColors.emeraldLight,
          onPrimaryContainer: AppColors.emeraldDark,
          secondary: AppColors.goldMedium,
          onSecondary: AppColors.goldDark,
          secondaryContainer: AppColors.goldLight,
          onSecondaryContainer: AppColors.goldDark,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.emerald,
          foregroundColor: AppColors.emeraldLight,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: AppColors.emeraldLight,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.emerald,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        dividerColor: AppColors.divider,
        textTheme: _textTheme(Brightness.light),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.emeraldMedium,
          brightness: Brightness.dark,
          primary: AppColors.emeraldMedium,
          secondary: AppColors.goldMedium,
          surface: AppColors.darkSurface,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkTextPrimary,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.08),
              width: 0.5,
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.emeraldMedium,
          unselectedItemColor: AppColors.darkTextSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        textTheme: _textTheme(Brightness.dark),
        dividerColor: AppColors.darkTextSecondary.withValues(alpha: 0.3),
      );

  static TextTheme _textTheme(Brightness brightness) {
    final textColor = brightness == Brightness.light
        ? AppColors.textPrimary
        : AppColors.darkTextPrimary;
    const fallback = ['Segoe UI', 'Roboto', 'Arial', 'sans-serif'];

    TextStyle baseStyle({
      required double fontSize,
      FontWeight fontWeight = FontWeight.normal,
    }) {
      return GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor,
        decoration: TextDecoration.none,
        height: 1.5,
      ).copyWith(fontFamilyFallback: fallback);
    }

    return TextTheme(
      headlineMedium: baseStyle(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: baseStyle(fontSize: 16, fontWeight: FontWeight.w500),
      titleSmall: baseStyle(fontSize: 14, fontWeight: FontWeight.w600),
      bodyLarge: baseStyle(fontSize: 16),
      bodyMedium: baseStyle(fontSize: 14),
      bodySmall: baseStyle(fontSize: 12),
      labelLarge: baseStyle(fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium: baseStyle(fontSize: 12),
      labelSmall: baseStyle(fontSize: 11),
    );
  }

  static TextStyle arabicTextStyle({
    double fontSize = 24,
    Color? color,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.scheherazadeNew(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight ?? FontWeight.w600,
      height: height ?? 2.0,
      letterSpacing: letterSpacing ?? 1.0,
    );
  }
}
