import 'package:flutter/material.dart';

/// Single source of truth for all color constants.
/// RULE (AGENTS.md): NO hardcoded colors in views — always use this class.
abstract class AppColors {
  // ── Dark Mode Palette ───────────────────────────────────────────────────────
  /// Base background — Matte Anthracite
  static const Color darkBackground = Color(0xFF111318);

  /// Surface layer 1 (cards, bottom nav)
  static const Color darkSurface = Color(0xFF1A1D25);

  /// Surface layer 2 (elevated cards, dialogs)
  static const Color darkSurface2 = Color(0xFF22262F);

  /// Glass overlay tint (used in BackdropFilter containers)
  static const Color darkGlass = Color(0x1AFFFFFF);

  /// Primary accent — Emerald Green
  static const Color darkAccentPrimary = Color(0xFF2ECC96);

  /// Secondary accent — Mint Green (lighter shade for gradients)
  static const Color darkAccentSecondary = Color(0xFF7FFFD4);

  /// Active prayer highlight glow
  static const Color darkAccentGlow = Color(0x402ECC96);

  /// Primary text on dark
  static const Color darkTextPrimary = Color(0xFFF2F4F8);

  /// Secondary / muted text on dark
  static const Color darkTextSecondary = Color(0xFF8B92A5);

  /// Disabled / hint text on dark
  static const Color darkTextHint = Color(0xFF4A5060);

  /// Divider / border lines on dark
  static const Color darkDivider = Color(0xFF2A2E3A);

  /// Error / warning color on dark
  static const Color darkError = Color(0xFFFF5F6D);

  // ── Light Mode Palette ──────────────────────────────────────────────────────
  /// Base background — Warm Off-White
  static const Color lightBackground = Color(0xFFF5F6F8);

  /// Surface layer 1 (cards, bottom nav)
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Surface layer 2 (elevated cards, dialogs)
  static const Color lightSurface2 = Color(0xFFEDF0F5);

  /// Glass overlay tint (used in BackdropFilter containers)
  static const Color lightGlass = Color(0x26FFFFFF);

  /// Primary accent — Sage / Forest Green
  static const Color lightAccentPrimary = Color(0xFF1E7A5F);

  /// Secondary accent — lighter sage
  static const Color lightAccentSecondary = Color(0xFF4CAF83);

  /// Active prayer highlight glow
  static const Color lightAccentGlow = Color(0x301E7A5F);

  /// Primary text on light
  static const Color lightTextPrimary = Color(0xFF0F1218);

  /// Secondary / muted text on light
  static const Color lightTextSecondary = Color(0xFF5A6072);

  /// Disabled / hint text on light
  static const Color lightTextHint = Color(0xFFADB5C2);

  /// Divider / border lines on light
  static const Color lightDivider = Color(0xFFE2E6ED);

  /// Error / warning color on light
  static const Color lightError = Color(0xFFD93025);

  // ── Gradient Definitions ────────────────────────────────────────────────────
  static const LinearGradient darkAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkAccentPrimary, darkAccentSecondary],
  );

  static const LinearGradient lightAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightAccentPrimary, lightAccentSecondary],
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0E1117), Color(0xFF161A22)],
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFEFF2F7), Color(0xFFF8F9FC)],
  );

  // ── Prayer Time Specific ────────────────────────────────────────────────────
  /// Imsak (Suhur) — deep indigo twilight
  static const Color prayerImsak = Color(0xFF5C6BC0);

  /// Güneş (Sunrise) — warm amber
  static const Color prayerSunrise = Color(0xFFF4A261);

  /// Öğle (Dhuhr) — sky blue
  static const Color prayerDhuhr = Color(0xFF42B4F5);

  /// İkindi (Asr) — golden hour
  static const Color prayerAsr = Color(0xFFE9A948);

  /// Akşam (Maghrib) — dusk orange-rose
  static const Color prayerMaghrib = Color(0xFFE07070);

  /// Yatsı (Isha) — deep midnight blue
  static const Color prayerIsha = Color(0xFF7986CB);
}
