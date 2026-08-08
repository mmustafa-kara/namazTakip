import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme.dart';
import '../services/notification_service.dart';
import '../services/service_providers.dart';
import '../services/turkey_location_service.dart';
import '../viewmodels/prayer_times_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';

/// Ayarlar Ekranı (Faz 6 + Eksiksiz 81 İl / 922 İlçe Konum Seçimi).
/// AGENTS.md: ConsumerWidget, Flat Premium stil (gölgesiz, 1px border'lı kartlar).
class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
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
                    // ── GÖREV: EKSİKSİZ KONUM AYARLARI (81 İL & 922 İLÇE) ──
                    _SectionHeader(title: 'KONUM AYARLARI', color: textHint),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: divider, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FutureBuilder(
                          future: ref.read(locationServiceProvider).getCustomLocation(),
                          builder: (context, snapshot) {
                            final customLoc = snapshot.data;
                            final isCustom = customLoc != null;
                            final locationText = isCustom
                                ? '${customLoc.name} (Manuel Sabit)'
                                : 'Otomatik GPS (Anlık Konum)';

                            return Material(
                              color: Colors.transparent,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                title: Text(
                                  'Konum Seçimi (81 İl / 922 İlçe)',
                                  style: AppTypography.headlineSmall(color: textPrimary)
                                      .copyWith(fontSize: 14),
                                ),
                                subtitle: Text(
                                  locationText,
                                  style: AppTypography.bodySmall(
                                      color: isCustom ? accent : textSecondary),
                                ),
                                trailing: Icon(
                                  isCustom
                                      ? Icons.edit_location_alt_rounded
                                      : Icons.my_location_rounded,
                                  color: accent,
                                  size: 20,
                                ),
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  _showLocationPickerDialog(context);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

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
                                ref
                                    .read(settingsProvider.notifier)
                                    .setThemeMode(ThemeMode.dark);
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
                                ref
                                    .read(settingsProvider.notifier)
                                    .setThemeMode(ThemeMode.light);
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
                                ref
                                    .read(settingsProvider.notifier)
                                    .setThemeMode(ThemeMode.system);
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
                    _SectionHeader(
                        title: 'BİLDİRİMLER VE ALGORİTMA', color: textHint),
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
                              subtitle:
                                  'Vakitlerde + 45dk/1s aralıklarla akıllı bildirimler',
                              isSelected:
                                  settings.notificationType == 'hatirlatici',
                              onTap: () {
                                HapticFeedback.selectionClick();
                                ref
                                    .read(settingsProvider.notifier)
                                    .setNotificationType('hatirlatici');
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
                                ref
                                    .read(settingsProvider.notifier)
                                    .setNotificationType('vakit');
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
                    _SectionHeader(
                        title: 'SİSTEM VE ETKİLEŞİM', color: textHint),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Dokunsal Titreşim (Haptic)',
                                    style: AppTypography.headlineSmall(
                                            color: textPrimary)
                                        .copyWith(fontSize: 14),
                                  ),
                                  CupertinoSwitch(
                                    activeTrackColor: accent,
                                    value: settings.hapticEnabled,
                                    onChanged: (val) {
                                      HapticFeedback.selectionClick();
                                      ref
                                          .read(settingsProvider.notifier)
                                          .setHapticEnabled(val);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1, color: divider),
                            Material(
                              color: Colors.transparent,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                title: Text(
                                  'Konum ve Vakitleri Yenile',
                                  style: AppTypography.headlineSmall(
                                          color: textPrimary)
                                      .copyWith(fontSize: 14),
                                ),
                                subtitle: Text(
                                  'Aylık takvimi yeniden çeker ve yeniler',
                                  style:
                                      AppTypography.bodySmall(color: textSecondary),
                                ),
                                trailing: Icon(Icons.refresh_rounded,
                                    color: accent, size: 20),
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  ref
                                      .read(prayerTimesProvider.notifier)
                                      .refreshData();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: surface2,
                                      content: Text(
                                        'Konum ve vakitler güncelleniyor...',
                                        style: AppTypography.bodySmall(
                                            color: textPrimary),
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
                    const SizedBox(height: 24),

                    // ── GELİŞTİRİCİ / HATA AYIKLAMA ──────────────────────────
                    _SectionHeader(title: 'HATA AYIKLAMA', color: textHint),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: divider, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            title: Text(
                              'Bildirim Testi (Anında)',
                              style: AppTypography.headlineSmall(color: accent)
                                  .copyWith(fontSize: 14),
                            ),
                            subtitle: Text(
                              'Altyapının çalıştığını test eder — anında bildirim gösterir',
                              style: AppTypography.bodySmall(
                                  color: textSecondary),
                            ),
                            trailing: Icon(Icons.notifications_active_rounded,
                                color: accent, size: 20),
                            onTap: () async {
                              HapticFeedback.mediumImpact();
                              try {
                                await NotificationService()
                                    .showTestNotification();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: surface2,
                                      content: Text(
                                        'Test bildirimi gönderildi! Bildirim geldiyse sistem çalışıyor.',
                                        style: AppTypography.bodySmall(
                                            color: textPrimary),
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: surface2,
                                      content: Text(
                                        'Bildirim hatası: $e',
                                        style: AppTypography.bodySmall(
                                            color: textPrimary),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
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

  /// GÖREV: 81 İl ve 922 İlçeli Eksiksiz Konum Seçim Modal BottomSheet'i
  void _showLocationPickerDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkAccentPrimary : AppColors.lightAccentPrimary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final divider = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return FutureBuilder<List<ProvinceModel>>(
          future: TurkeyLocationService().loadProvinces(),
          builder: (ctx, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: CircularProgressIndicator(color: accent),
                ),
              );
            }

            final provinces = snapshot.data!;

            ProvinceModel selectedProvince = provinces.firstWhere(
              (p) => p.name.toUpperCase() == 'BURSA',
              orElse: () => provinces.first,
            );

            DistrictModel selectedDistrict = selectedProvince.districts.firstWhere(
              (d) => d.name.toUpperCase() == 'İNEGÖL',
              orElse: () => selectedProvince.districts.first,
            );

            return StatefulBuilder(
              builder: (ctx, setBottomSheetState) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 20,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: divider,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Konum Seçin',
                        style: AppTypography.headlineMedium(color: textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Türkiye\'deki 81 il ve 922 ilçe arasından seçim yapın',
                        style: AppTypography.bodySmall(color: textSecondary),
                      ),
                      const SizedBox(height: 20),

                      // İl Dropdown
                      Text('İl (81 İl)', style: AppTypography.labelMedium(color: accent)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: surface2,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: divider),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<ProvinceModel>(
                            value: selectedProvince,
                            isExpanded: true,
                            dropdownColor: surface2,
                            style: AppTypography.bodyMedium(color: textPrimary),
                            items: provinces.map((province) {
                              return DropdownMenuItem<ProvinceModel>(
                                value: province,
                                child: Text('${province.plateCode} - ${province.name}'),
                              );
                            }).toList(),
                            onChanged: (newProvince) {
                              if (newProvince != null) {
                                setBottomSheetState(() {
                                  selectedProvince = newProvince;
                                  selectedDistrict = newProvince.districts.first;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // İlçe Dropdown
                      Text(
                        'İlçe (${selectedProvince.districts.length} İlçe)',
                        style: AppTypography.labelMedium(color: accent),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: surface2,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: divider),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<DistrictModel>(
                            value: selectedDistrict,
                            isExpanded: true,
                            dropdownColor: surface2,
                            style: AppTypography.bodyMedium(color: textPrimary),
                            items: selectedProvince.districts.map((district) {
                              return DropdownMenuItem<DistrictModel>(
                                value: district,
                                child: Text(district.name),
                              );
                            }).toList(),
                            onChanged: (newDistrict) {
                              if (newDistrict != null) {
                                setBottomSheetState(() {
                                  selectedDistrict = newDistrict;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.pop(ctx);
                                final locService = ref.read(locationServiceProvider);
                                await locService.clearCustomLocation();
                                setState(() {});
                                ref.read(prayerTimesProvider.notifier).refreshData();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: surface2,
                                      content: Text(
                                        'Otomatik GPS moduna geçildi.',
                                        style: AppTypography.bodySmall(color: textPrimary),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: surface2,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: divider),
                                ),
                                child: Center(
                                  child: Text(
                                    'Otomatik GPS',
                                    style: AppTypography.labelMedium(color: textSecondary),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.pop(ctx);

                                // İlerleme indicator'ı göster
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: surface2,
                                      content: Text(
                                        'Konum koordinatları hesaplanıyor...',
                                        style: AppTypography.bodySmall(color: textPrimary),
                                      ),
                                    ),
                                  );
                                }

                                final coords = await TurkeyLocationService()
                                    .getCoordinatesForDistrict(
                                  provinceName: selectedProvince.name,
                                  districtName: selectedDistrict.name,
                                );

                                final locService = ref.read(locationServiceProvider);
                                await locService.saveCustomLocation(
                                  city: selectedProvince.name,
                                  district: selectedDistrict.name,
                                  latitude: coords.latitude,
                                  longitude: coords.longitude,
                                );

                                setState(() {});
                                ref.read(prayerTimesProvider.notifier).refreshData();

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: surface2,
                                      content: Text(
                                        'Konum sabitlendi: ${selectedProvince.name} / ${selectedDistrict.name}',
                                        style: AppTypography.bodySmall(color: textPrimary),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: accent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    'Konumu Kaydet',
                                    style: AppTypography.labelMedium(
                                      color: isDark ? AppColors.darkBackground : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
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
