import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
        ),
        textTheme: _textTheme(Brightness.light),
        dividerColor: AppColors.divider,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryLight,
          brightness: Brightness.dark,
          primary: AppColors.primaryLight,
          secondary: AppColors.accent,
          surface: AppColors.darkSurface,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkTextPrimary,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkSurface,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.primaryLight,
          unselectedItemColor: AppColors.darkTextSecondary,
          type: BottomNavigationBarType.fixed,
        ),
        textTheme: _textTheme(Brightness.dark),
        dividerColor: AppColors.darkTextSecondary.withValues(alpha: 0.3),
      );

  static TextTheme _textTheme(Brightness brightness) {
    final base = brightness == Brightness.light
        ? ThemeData.light().textTheme
        : ThemeData.dark().textTheme;
    return base.copyWith(
      headlineMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      titleMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      bodyLarge: GoogleFonts.poppins(fontSize: 16),
      bodyMedium: GoogleFonts.poppins(fontSize: 14),
    );
  }

  static TextStyle arabicTextStyle({
    double fontSize = 24,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return GoogleFonts.amiri(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      height: 1.8,
    );
  }
}
