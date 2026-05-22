import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.neonPurple,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonPurple,
        secondary: AppColors.neonCyan,
        background: AppColors.backgroundDark,
        surface: AppColors.backgroundSlate,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontSize: 36,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        labelLarge: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      primaryColor: AppColors.neonPurple,
      colorScheme: const ColorScheme.light(
        primary: AppColors.neonPurple,
        secondary: AppColors.neonCyan,
        background: Color(0xFFF8FAFC),
        surface: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          color: const Color(0xFF0F172A),
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.outfit(
          color: const Color(0xFF0F172A),
          fontSize: 36,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.outfit(
          color: const Color(0xFF0F172A),
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: const Color(0xFF334155),
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          color: const Color(0xFF64748B),
          fontSize: 14,
        ),
        labelLarge: GoogleFonts.inter(
          color: const Color(0xFF0F172A),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
