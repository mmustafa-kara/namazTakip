import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/theme.dart';

/// Minimalist, Flat Premium Kıble Pusulası Kadranı.
/// OPTIMIZATIONS.md: 60 FPS dönme animasyonu sadece bu widget içinde izole edilir.
class CompassDialWidget extends StatefulWidget {
  /// Cihazın Kuzey'e göre anlık açısı (0..360)
  final double heading;

  /// Kullanıcının konumuna göre Kâbe'nin Kuzey'e olan açısı (0..360)
  final double qiblaBearing;

  const CompassDialWidget({
    super.key,
    required this.heading,
    required this.qiblaBearing,
  });

  @override
  State<CompassDialWidget> createState() => _CompassDialWidgetState();
}

class _CompassDialWidgetState extends State<CompassDialWidget> {
  bool _wasAligned = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkAccentPrimary : AppColors.lightAccentPrimary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final divider = isDark ? AppColors.darkDivider : AppColors.lightDivider;
    final surface = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;

    // Cihazın tepe noktasının Kâbe yönüne göre bağıl açısı
    final double diff = (widget.qiblaBearing - widget.heading + 360) % 360;
    final double relativeDiff = diff > 180 ? diff - 360 : diff;

    // Tam Kıble hizasında mıyız? (±3 derece tolerans)
    final bool isAligned = relativeDiff.abs() <= 3.0;

    // Hizalandığı anda tek seferlik titreşim (Haptic Feedback)
    if (isAligned && !_wasAligned) {
      _wasAligned = true;
      HapticFeedback.mediumImpact();
    } else if (!isAligned && _wasAligned) {
      _wasAligned = false;
    }

    // Pusula kadranının dönme açısı (Radyan)
    final double dialAngleRad = -widget.heading * (math.pi / 180);
    // Kâbe göstergesinin kadrandaki konumu (Radyan)
    final double qiblaAngleRad = widget.qiblaBearing * (math.pi / 180);

    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: surface,
        border: Border.all(
          color: isAligned ? accent : divider,
          width: isAligned ? 2 : 1,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dönel Pusula Kadranı (Kuzey, Doğu, Güney, Batı)
          Transform.rotate(
            angle: dialAngleRad,
            child: SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Kuzey (K) - Kırmızı İndikatör
                  Positioned(
                    top: 14,
                    child: Text(
                      'K',
                      style: AppTypography.labelLarge(
                        color: isDark ? AppColors.darkError : AppColors.lightError,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Güney (G)
                  Positioned(
                    bottom: 14,
                    child: Text(
                      'G',
                      style: AppTypography.labelSmall(
                        color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
                      ),
                    ),
                  ),
                  // Doğu (D)
                  Positioned(
                    right: 16,
                    child: Text(
                      'D',
                      style: AppTypography.labelSmall(
                        color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
                      ),
                    ),
                  ),
                  // Batı (B)
                  Positioned(
                    left: 16,
                    child: Text(
                      'B',
                      style: AppTypography.labelSmall(
                        color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
                      ),
                    ),
                  ),
                  // Derece Çizgileri
                  ...List.generate(12, (index) {
                    final angle = index * 30 * (math.pi / 180);
                    return Transform.rotate(
                      angle: angle,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: index % 3 == 0 ? 2 : 1,
                          height: index % 3 == 0 ? 8 : 4,
                          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                        ),
                      ),
                    );
                  }),
                  // Kâbe Göstergesi (Emerald Accent İbre)
                  Transform.rotate(
                    angle: qiblaAngleRad,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.only(top: 26),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.navigation_rounded,
                              color: accent,
                              size: 30,
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: accent, width: 1),
                              ),
                              child: Text(
                                'KÂBE',
                                style: AppTypography.labelSmall(color: accent).copyWith(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Cihazın baktığı sabit tepe noktası göstergesi
          Positioned(
            top: 4,
            child: Icon(
              Icons.arrow_drop_down_rounded,
              size: 28,
              color: isAligned ? accent : textPrimary,
            ),
          ),

          // Merkez Göbek Noktası
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAligned ? accent : surface,
              border: Border.all(
                color: isAligned ? accent : textPrimary,
                width: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
