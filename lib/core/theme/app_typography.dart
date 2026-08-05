import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Single source of truth for all typography.
/// RULE (AGENTS.md): ALL text MUST use these definitions — never system fonts.
///
/// Primary display font : Outfit  (headings, countdowns, large numbers)
/// Body / UI font        : Inter   (labels, body text, captions)
abstract class AppTypography {
  // ── Display / Heading Styles (Outfit) ───────────────────────────────────────

  /// 48sp — Hero countdown timer digits
  static TextStyle displayLarge({Color? color}) => GoogleFonts.outfit(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: color,
      );

  /// 36sp — Section headings, date display
  static TextStyle displayMedium({Color? color}) => GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: color,
      );

  /// 28sp — Card title, city name
  static TextStyle displaySmall({Color? color}) => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: color,
      );

  /// 22sp — Screen-level headings
  static TextStyle headlineLarge({Color? color}) => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: color,
      );

  /// 18sp — Sub-section headings
  static TextStyle headlineMedium({Color? color}) => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: color,
      );

  /// 15sp — Prayer name labels in cards
  static TextStyle headlineSmall({Color? color}) => GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: color,
      );

  // ── Body / UI Styles (Inter) ────────────────────────────────────────────────

  /// 16sp — Default body text
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: color,
      );

  /// 14sp — Secondary body / description text
  static TextStyle bodyMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: color,
      );

  /// 12sp — Captions, meta info, timestamps
  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: color,
      );

  // ── Label / Interactive Styles (Inter) ─────────────────────────────────────

  /// 14sp SemiBold — Button labels, nav items
  static TextStyle labelLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: color,
      );

  /// 12sp Medium — Chip labels, badges
  static TextStyle labelMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: color,
      );

  /// 10sp Medium — Overlines, micro-labels, nav bar icon labels
  static TextStyle labelSmall({Color? color}) => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0,
        color: color,
      );

  // ── Specialised / Prayer UI ─────────────────────────────────────────────────

  /// 56sp Bold — Main countdown timer (Outfit, tabular nums)
  static TextStyle timerDisplay({Color? color}) => GoogleFonts.outfit(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        letterSpacing: -2.0,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: color,
      );

  /// 13sp SemiBold with wide spacing — Section overlines / labels
  static TextStyle overline({Color? color}) => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.5,
        color: color,
      );

  // ── ThemeData text theme helpers ────────────────────────────────────────────

  /// Build a [TextTheme] for dark mode.
  static TextTheme darkTextTheme() => TextTheme(
        displayLarge: displayLarge(color: AppColors.darkTextPrimary),
        displayMedium: displayMedium(color: AppColors.darkTextPrimary),
        displaySmall: displaySmall(color: AppColors.darkTextPrimary),
        headlineLarge: headlineLarge(color: AppColors.darkTextPrimary),
        headlineMedium: headlineMedium(color: AppColors.darkTextPrimary),
        headlineSmall: headlineSmall(color: AppColors.darkTextPrimary),
        bodyLarge: bodyLarge(color: AppColors.darkTextSecondary),
        bodyMedium: bodyMedium(color: AppColors.darkTextSecondary),
        bodySmall: bodySmall(color: AppColors.darkTextHint),
        labelLarge: labelLarge(color: AppColors.darkTextPrimary),
        labelMedium: labelMedium(color: AppColors.darkTextSecondary),
        labelSmall: labelSmall(color: AppColors.darkTextHint),
      );

  /// Build a [TextTheme] for light mode.
  static TextTheme lightTextTheme() => TextTheme(
        displayLarge: displayLarge(color: AppColors.lightTextPrimary),
        displayMedium: displayMedium(color: AppColors.lightTextPrimary),
        displaySmall: displaySmall(color: AppColors.lightTextPrimary),
        headlineLarge: headlineLarge(color: AppColors.lightTextPrimary),
        headlineMedium: headlineMedium(color: AppColors.lightTextPrimary),
        headlineSmall: headlineSmall(color: AppColors.lightTextPrimary),
        bodyLarge: bodyLarge(color: AppColors.lightTextSecondary),
        bodyMedium: bodyMedium(color: AppColors.lightTextSecondary),
        bodySmall: bodySmall(color: AppColors.lightTextHint),
        labelLarge: labelLarge(color: AppColors.lightTextPrimary),
        labelMedium: labelMedium(color: AppColors.lightTextSecondary),
        labelSmall: labelSmall(color: AppColors.lightTextHint),
      );
}
