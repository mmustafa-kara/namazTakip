import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Uygulama ayarlarının durum sınıfı.
class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final bool hapticEnabled;
  final String notificationType; // "vakit" veya "hatirlatici"

  const SettingsState({
    this.themeMode = ThemeMode.dark,
    this.hapticEnabled = true,
    this.notificationType = 'hatirlatici',
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? hapticEnabled,
    String? notificationType,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  @override
  List<Object?> get props => [themeMode, hapticEnabled, notificationType];
}

/// Ayarlar durumunu yöneten Riverpod Provider.
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  static const String _keyTheme = 'settings_theme_mode';
  static const String _keyHaptic = 'settings_haptic_enabled';
  static const String _keyNotifType = 'settings_notification_type';

  SettingsNotifier() : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_keyTheme) ?? ThemeMode.dark.index;
      final haptic = prefs.getBool(_keyHaptic) ?? true;
      final notifType = prefs.getString(_keyNotifType) ?? 'hatirlatici';

      state = SettingsState(
        themeMode: ThemeMode.values[themeIndex],
        hapticEnabled: haptic,
        notificationType: notifType,
      );
    } catch (_) {}
  }

  /// Tema modunu değiştirir (Dark/Light/System) ve kaydeder
  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyTheme, mode.index);
    } catch (_) {}
  }

  /// Titreşim tercihini açar/kapatır
  Future<void> setHapticEnabled(bool enabled) async {
    state = state.copyWith(hapticEnabled: enabled);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyHaptic, enabled);
    } catch (_) {}
  }

  /// Bildirim tipini değiştirir ("vakit" veya "hatirlatici")
  Future<void> setNotificationType(String type) async {
    state = state.copyWith(notificationType: type);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyNotifType, type);
    } catch (_) {}
  }
}
