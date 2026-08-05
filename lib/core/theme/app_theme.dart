import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Builds the [ThemeData] for dark and light modes.
/// RULE (AGENTS.md): Flat / glassmorphism UI — no Material elevation shadows.
abstract class AppTheme {
  // ── Dark Theme ──────────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.darkAccentPrimary,
          secondary: AppColors.darkAccentSecondary,
          surface: AppColors.darkSurface,
          error: AppColors.darkError,
          onPrimary: AppColors.darkBackground,
          onSecondary: AppColors.darkBackground,
          onSurface: AppColors.darkTextPrimary,
          onError: AppColors.darkTextPrimary,
        ),
        textTheme: AppTypography.darkTextTheme(),

        // ── Remove all Material shadows (glassmorphism style) ──────────────────
        cardTheme: const CardThemeData(
          color: AppColors.darkSurface,
          shadowColor: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: AppColors.darkAccentPrimary,
            foregroundColor: AppColors.darkBackground,
            textStyle: AppTypography.labelLarge(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkBackground,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: AppTypography.headlineMedium(
            color: AppColors.darkTextPrimary,
          ),
          iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.darkDivider,
          thickness: 1,
          space: 1,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.darkAccentPrimary,
          unselectedItemColor: AppColors.darkTextHint,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.darkTextSecondary,
          size: 22,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurface2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.darkAccentPrimary
                : AppColors.darkTextHint,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.darkAccentGlow
                : AppColors.darkSurface2,
          ),
        ),
      );

  // ── Light Theme ─────────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBackground,
        colorScheme: const ColorScheme.light(
          primary: AppColors.lightAccentPrimary,
          secondary: AppColors.lightAccentSecondary,
          surface: AppColors.lightSurface,
          error: AppColors.lightError,
          onPrimary: AppColors.lightSurface,
          onSecondary: AppColors.lightSurface,
          onSurface: AppColors.lightTextPrimary,
          onError: AppColors.lightSurface,
        ),
        textTheme: AppTypography.lightTextTheme(),

        // ── Remove all Material shadows ────────────────────────────────────────
        cardTheme: const CardThemeData(
          color: AppColors.lightSurface,
          shadowColor: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: AppColors.lightAccentPrimary,
            foregroundColor: AppColors.lightSurface,
            textStyle: AppTypography.labelLarge(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.lightBackground,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: AppTypography.headlineMedium(
            color: AppColors.lightTextPrimary,
          ),
          iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.lightDivider,
          thickness: 1,
          space: 1,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.lightSurface,
          selectedItemColor: AppColors.lightAccentPrimary,
          unselectedItemColor: AppColors.lightTextHint,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.lightTextSecondary,
          size: 22,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightSurface2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.lightAccentPrimary
                : AppColors.lightTextHint,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.lightAccentGlow
                : AppColors.lightSurface2,
          ),
        ),
      );
}
