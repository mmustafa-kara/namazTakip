import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme.dart';
import '../models/prayer_time.dart';
import '../services/service_providers.dart';
import '../utils/prayer_schedule_helper.dart';
import '../viewmodels/prayer_times_viewmodel.dart';
import '../widgets/countdown_timer_widget.dart';
import '../widgets/prayer_time_card.dart';

/// Ana ekran (Dashboard). Tüm Faz 1-3 çıktılarını tek çatı altında birleştirir.
/// AGENTS.md: ConsumerWidget kullan, setState ile iş mantığı yönetme.
/// AGENTS.md: View 200 satırı geçmemeli — ağır bölümler alt widget'lara bölündü.
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sistem status bar'ını transparan yap (edge-to-edge görünüm)
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
    );

    final prayerAsync = ref.watch(prayerTimesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // AGENTS.md: Material AppBar kullanılmıyor — özel header widget'ı kullanılıyor
      body: prayerAsync.when(
        loading: () => const _LoadingState(),
        error: (error, _) => _ErrorState(
          message: error.toString(),
          onRetry: () => ref.read(prayerTimesProvider.notifier).refreshData(),
        ),
        data: (prayerTime) {
          if (prayerTime == null) {
            return _ErrorState(
              message: 'Namaz vakitleri bulunamadı.\nİnternet bağlantınızı kontrol edin.',
              onRetry: () => ref.read(prayerTimesProvider.notifier).refreshData(),
            );
          }
          return _HomeContent(prayerTime: prayerTime);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOADING STATE
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkAccentPrimary : AppColors.lightAccentPrimary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: accent,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Namaz vakitleri yükleniyor...',
            style: AppTypography.bodyMedium(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR STATE
// ─────────────────────────────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkAccentPrimary : AppColors.lightAccentPrimary;
    final errorColor = isDark ? AppColors.darkError : AppColors.lightError;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surface = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;

    // Teknik hata mesajlarını kullanıcı dostu hale getir
    final friendlyMessage = message.contains('Exception:')
        ? message.replaceFirst('Exception: ', '')
        : message;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hata ikonu — Flat Premium kutucuk
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: errorColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: errorColor.withValues(alpha: 0.25)),
                ),
                child: Icon(Icons.wifi_off_rounded, size: 40, color: errorColor),
              ),
              const SizedBox(height: 24),
              Text(
                'Bağlantı Hatası',
                style: AppTypography.headlineMedium(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                friendlyMessage,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium(color: textSecondary),
              ),
              const SizedBox(height: 32),
              // Tekrar Dene butonu — Flat Premium, gölgesiz
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accent, width: 1),
                  ),
                  child: Text(
                    'Tekrar Dene',
                    style: AppTypography.labelLarge(color: accent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN CONTENT  (başarılı veri durumu)
// OPTIMIZATIONS.md: Consumer tüm sayfayı değil, sadece gerekli bölümleri sarar.
// ─────────────────────────────────────────────────────────────────────────────
class _HomeContent extends StatelessWidget {
  final PrayerTime prayerTime;

  const _HomeContent({required this.prayerTime});

  @override
  Widget build(BuildContext context) {
    final entries = PrayerScheduleHelper.getPrayerEntries(prayerTime);
    final activeIndex = PrayerScheduleHelper.getActiveIndex(entries);
    final nextPrayerTime = PrayerScheduleHelper.getNextPrayerTime(entries);
    final nextPrayerName = PrayerScheduleHelper.getNextPrayerName(entries);
    final todayFormatted = PrayerScheduleHelper.formatTurkishDate(DateTime.now());

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── HERO SECTION ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _HeroSection(
              dateString: todayFormatted,
              nextPrayerName: nextPrayerName,
              nextPrayerTime: nextPrayerTime,
            ),
          ),

          // ── VAKIT LİSTESİ BAŞLIĞI ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
              child: Text(
                'GÜNLÜK VAKİTLER',
                style: AppTypography.overline(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkTextHint
                      : AppColors.lightTextHint,
                ),
              ),
            ),
          ),

          // ── VAKIT KARTLARI ────────────────────────────────────────────────
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final entry = entries[index];
                return PrayerTimeCard(
                  prayerName: entry.name,
                  timeString: entry.time,
                  isActive: index == activeIndex,
                );
              },
              childCount: entries.length,
            ),
          ),

          // Alt boşluk
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO SECTION  (Tarih + Countdown)
// ─────────────────────────────────────────────────────────────────────────────
class _HeroSection extends ConsumerWidget {
  final String dateString;
  final String nextPrayerName;
  final DateTime nextPrayerTime;

  const _HeroSection({
    required this.dateString,
    required this.nextPrayerName,
    required this.nextPrayerTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkAccentPrimary : AppColors.lightAccentPrimary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final textHint = isDark ? AppColors.darkTextHint : AppColors.lightTextHint;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final divider = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Tarih
          Text(
            dateString,
            style: AppTypography.bodyMedium(color: textHint),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),

          // "Sonraki vakit" etiketi
          Text(
            'Sıradaki Vakit',
            style: AppTypography.overline(color: textSecondary),
          ),
          const SizedBox(height: 8),

          // Vakit adı
          Text(
            nextPrayerName,
            style: AppTypography.headlineLarge(color: textPrimary),
          ),
          const SizedBox(height: 16),

          // ── COUNTDOWN — sadece bu widget rebuild edilir (OPTIMIZATIONS.md) ──
          CountdownTimerWidget(targetTime: nextPrayerTime),

          const SizedBox(height: 8),
          Text(
            'kalan süre',
            style: AppTypography.bodySmall(color: textHint),
          ),

          const SizedBox(height: 20),

          // İnce separator çizgisi
          Container(height: 1, color: divider),
          const SizedBox(height: 20),

          // Accent location badge — Dinamik Konum Gösterimi
          FutureBuilder(
            future: ref.read(locationServiceProvider).getCustomLocation(),
            builder: (context, snapshot) {
              final locText = snapshot.data != null
                  ? snapshot.data!.name
                  : 'Otomatik Konum (GPS)';

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: accent.withValues(alpha: 0.3), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_rounded, size: 14, color: accent),
                    const SizedBox(width: 6),
                    Text(
                      locText,
                      style: AppTypography.labelSmall(color: accent),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
