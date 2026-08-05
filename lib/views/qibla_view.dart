import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme.dart';
import '../viewmodels/qibla_viewmodel.dart';
import '../widgets/compass_dial_widget.dart';

/// Kıble Pusulası Ekranı (Faz 5).
/// AGENTS.md: ConsumerWidget, Flat Premium stil, <200 satır view sınırı.
/// OPTIMIZATIONS.md: 60 FPS pusula güncellemeleri yalnızca [CompassDialWidget] 
/// ve lokal [Consumer] içerisinde izole edilir.
class QiblaView extends ConsumerWidget {
  const QiblaView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkAccentPrimary : AppColors.lightAccentPrimary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final textHint = isDark ? AppColors.darkTextHint : AppColors.lightTextHint;

    final qiblaBearingAsync = ref.watch(qiblaBearingProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Başlık
              Text(
                'Kıble Pusulası',
                style: AppTypography.headlineLarge(color: textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                'Konumunuza özel Kâbe yönü',
                style: AppTypography.bodySmall(color: textHint),
              ),

              const Spacer(),

              // Kıble açısı hesaplama durumu (Location -> Qibla Bearing)
              qiblaBearingAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (err, _) => Center(
                  child: Text(
                    'Konum alınamadı: $err',
                    style: AppTypography.bodyMedium(
                      color: isDark ? AppColors.darkError : AppColors.lightError,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                data: (qiblaBearing) {
                  // Pusula sensör yayınını (Stream) izole olarak dinliyoruz
                  return Consumer(
                    builder: (context, ref, _) {
                      final compassAsync = ref.watch(compassStreamProvider);

                      return compassAsync.when(
                        loading: () => const CircularProgressIndicator(),
                        error: (err, _) => Text(
                          'Pusula sensörü okunamadı',
                          style: AppTypography.bodyMedium(color: textHint),
                        ),
                        data: (compassEvent) {
                          if (compassEvent == null || compassEvent.heading == null) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.compass_calibration_outlined, size: 48, color: textHint),
                                const SizedBox(height: 12),
                                Text(
                                  'Cihazınızda pusula sensörü bulunamadı veya kalibre ediliyor.',
                                  style: AppTypography.bodyMedium(color: textSecondary),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          }

                          final double heading = compassEvent.heading!;
                          final double diff = (qiblaBearing - heading + 360) % 360;
                          final double relativeDiff = diff > 180 ? diff - 360 : diff;
                          final bool isAligned = relativeDiff.abs() <= 3.0;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // OPTIMIZATIONS.md: 60 FPS pusula dönüşü burada izole edilir
                              CompassDialWidget(
                                heading: heading,
                                qiblaBearing: qiblaBearing,
                              ),

                              const SizedBox(height: 40),

                              // Sapma derecesi bilgi kartı (Flat Premium)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                decoration: BoxDecoration(
                                  color: isAligned
                                      ? accent.withValues(alpha: 0.12)
                                      : (isDark ? AppColors.darkSurface2 : AppColors.lightSurface2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isAligned
                                        ? accent
                                        : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isAligned ? Icons.check_circle_rounded : Icons.explore_outlined,
                                      color: isAligned ? accent : textSecondary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      isAligned
                                          ? 'Kıble Yönündesiniz (${qiblaBearing.toStringAsFixed(0)}°)'
                                          : 'Kıble: ${qiblaBearing.toStringAsFixed(0)}°  |  Pusula: ${heading.toStringAsFixed(0)}°',
                                      style: AppTypography.labelLarge(
                                        color: isAligned ? accent : textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),

              const Spacer(),

              // Alt kalibrasyon ipucu
              Text(
                'Doğru sonuç için telefonunuzu düz tutun ve 8 şeklinde sallayın.',
                style: AppTypography.bodySmall(color: textHint),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
