import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme.dart';
import '../viewmodels/zikir_viewmodel.dart';

/// Zikirmatik Ekranı (Faz 7).
/// AGENTS.md: ConsumerWidget, Flat Premium stil, <200 satır view sınırı.
/// OPTIMIZATIONS.md: Tıklamalar esnasında tüm sayfanın yeniden çizilmesini
/// önlemek için sayaç değişimi lokal [Consumer] içerisinde izole edilir.
class ZikirmatikView extends ConsumerWidget {
  const ZikirmatikView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark
        ? AppColors.darkAccentPrimary
        : AppColors.lightAccentPrimary;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final textHint = isDark ? AppColors.darkTextHint : AppColors.lightTextHint;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final divider = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Üst Header (Başlık ve Sıfırla Butonu)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zikirmatik',
                        style: AppTypography.headlineLarge(color: textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Günlük zikir ve tesbihat',
                        style: AppTypography.bodySmall(color: textHint),
                      ),
                    ],
                  ),
                  // Flat Premium Sıfırla Butonu
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      ref.read(zikirCountProvider.notifier).reset();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: surface2,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: divider, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            size: 16,
                            color: textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Sıfırla',
                            style: AppTypography.labelMedium(
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // OPTIMIZATIONS.md: Sadece Zikir Butonu ve Sayı rebuild edilir
              Consumer(
                builder: (context, ref, _) {
                  final count = ref.watch(zikirCountProvider);
                  final int cycleProgress = count % 33;
                  final int totalCycles = count ~/ 33;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tur ve Döngü Bilgisi
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '$totalCycles Tur  •  $cycleProgress / 33',
                          style: AppTypography.labelMedium(color: accent),
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Devasa İnteraktif Zikir Butonu (Flat Premium)
                      GestureDetector(
                        onTap: () {
                          // count: Riverpod'dan gelen MEVCUT (artırılmadan önceki) değer.
                          // newCount: artırıldıktan sonraki değer.
                          final newCount = count + 1;

                          // Haptic'i ÖNCE çağır (async increment'ten önce) — race condition yok
                          if (newCount % 33 == 0) {
                            HapticFeedback.heavyImpact();
                          } else {
                            HapticFeedback.lightImpact();
                          }

                          // Ardından state'i artır ve kaydet
                          ref.read(zikirCountProvider.notifier).increment();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: surface,
                            border: Border.all(
                              color: cycleProgress == 0 && count > 0
                                  ? accent
                                  : divider,
                              width: cycleProgress == 0 && count > 0 ? 3 : 2,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$count',
                                  style: AppTypography.timerDisplay(
                                    color: textPrimary,
                                  ).copyWith(fontSize: 64),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'DOKUN',
                                  style: AppTypography.overline(
                                    color: textHint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
