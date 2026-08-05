import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme.dart';
import '../viewmodels/prayer_times_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';

/// Ayarlar Ekranı (Faz 6).
/// AGENTS.md: ConsumerWidget, Flat Premium stil (gölgesiz, 1px border'lı kartlar), <200 satır.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkAccentPrimary : AppColors.lightAccentPrimary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final textHint = isDark ? AppColors.darkTextHint : AppColors.lightTextHint;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final divider = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                'Ayarlar',
                style: AppTypography.headlineLarge(color: textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                'Uygulama ve bildirim tercihlerinizi özelleştirin',
                style: AppTypography.bodySmall(color: textHint),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // ── GÖRÜNÜM KATEGORİSİ ─────────────────────────────────
                    _SectionHeader(title: 'GÖRÜNÜM', color: textHint),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: divider, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          children: [
                            _ThemeTile(
                              title: 'Karanlık Tema',
                              isSelected: settings.themeMode == ThemeMode.dark,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.dark);
                              },
                              accent: accent,
                              textPrimary: textPrimary,
                            ),
                            Divider(height: 1, color: divider),
                            _ThemeTile(
                              title: 'Açık Tema',
                              isSelected: settings.themeMode == ThemeMode.light,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.light);
                              },
                              accent: accent,
                              textPrimary: textPrimary,
                            ),
                            Divider(height: 1, color: divider),
                            _ThemeTile(
                              title: 'Sistem Teması',
                              isSelected: settings.themeMode == ThemeMode.system,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.system);
                              },
                              accent: accent,
                              textPrimary: textPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── BİLDİRİMLER KATEGORİSİ ──────────────────────────────
                    _SectionHeader(title: 'BİLDİRİMLER VE ALGORİTMA', color: textHint),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: divider, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          children: [
                            _NotifTypeTile(
                              title: 'Akıllı Hatırlatıcılar (Önerilen)',
                              subtitle: 'Vakitlerde + 45dk/1s aralıklarla akıllı bildirimler',
                              isSelected: settings.notificationType == 'hatirlatici',
                              onTap: () {
                                HapticFeedback.selectionClick();
                                ref.read(settingsProvider.notifier).setNotificationType('hatirlatici');
                              },
                              accent: accent,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                            ),
                            Divider(height: 1, color: divider),
                            _NotifTypeTile(
                              title: 'Sadece Vakit Bildirimi',
                              subtitle: 'Yalnızca vakit girdiğinde tek 1 bildirim',
                              isSelected: settings.notificationType == 'vakit',
                              onTap: () {
                                HapticFeedback.selectionClick();
                                ref.read(settingsProvider.notifier).setNotificationType('vakit');
                              },
                              accent: accent,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── SİSTEM VE ETKİLEŞİM KATEGORİSİ ───────────────────────
                    _SectionHeader(title: 'SİSTEM VE ETKİLEŞİM', color: textHint),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: divider, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Dokunsal Titreşim (Haptic)',
                                    style: AppTypography.headlineSmall(color: textPrimary).copyWith(fontSize: 14),
                                  ),
                                  CupertinoSwitch(
                                    activeTrackColor: accent,
                                    value: settings.hapticEnabled,
                                    onChanged: (val) {
                                      HapticFeedback.selectionClick();
                                      ref.read(settingsProvider.notifier).setHapticEnabled(val);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1, color: divider),
                            Material(
                              color: Colors.transparent,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                title: Text(
                                  'Konum ve Vakitleri Yenile',
                                  style: AppTypography.headlineSmall(color: textPrimary).copyWith(fontSize: 14),
                                ),
                                subtitle: Text(
                                  'GPS konumunu alıp aylık takvimi yeniden çeker',
                                  style: AppTypography.bodySmall(color: textSecondary),
                                ),
                                trailing: Icon(Icons.refresh_rounded, color: accent, size: 20),
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  ref.read(prayerTimesProvider.notifier).refreshData();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: surface2,
                                      content: Text(
                                        'Konum ve vakitler güncelleniyor...',
                                        style: AppTypography.bodySmall(color: textPrimary),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: AppTypography.overline(color: color),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accent;
  final Color textPrimary;

  const _ThemeTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.accent,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        title: Text(
          title,
          style: AppTypography.headlineSmall(color: textPrimary).copyWith(fontSize: 14),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle_rounded, color: accent, size: 20)
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _NotifTypeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;

  const _NotifTypeTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          title,
          style: AppTypography.headlineSmall(color: textPrimary).copyWith(fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall(color: textSecondary),
        ),
        trailing: isSelected
            ? Icon(Icons.radio_button_checked_rounded, color: accent, size: 20)
            : Icon(Icons.radio_button_off_rounded, color: textSecondary, size: 20),
      ),
    );
  }
}
