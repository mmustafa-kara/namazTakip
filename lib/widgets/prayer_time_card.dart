import 'package:flutter/material.dart';
import '../core/theme/theme.dart';

/// Namaz vakitlerini ana ekranda (Dashboard) listeleyen widget.
/// YENİ KURAL (Flat Premium): Gölge veya blur yok. 1px kenarlık, oval köşeler (r=24) 
/// ve kontrast ile derinlik hissi yaratılıyor.
class PrayerTimeCard extends StatelessWidget {
  final String prayerName;
  final String timeString;
  
  /// Eğer o anki vakit içindeysek true yapılır. Kart vurgulu hale gelir.
  final bool isActive;
  final IconData? icon;

  const PrayerTimeCard({
    super.key,
    required this.prayerName,
    required this.timeString,
    this.isActive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Flat Premium Design: No shadows, just subtle borders and background color
    final bgColor = isActive 
        ? colors.primary.withValues(alpha: 0.12) // Vurgulu (aktif) arka plan
        : (isDark ? AppColors.darkSurface2 : AppColors.lightSurface2);
        
    final borderColor = isActive 
        ? colors.primary.withValues(alpha: 0.5) // Aktif kart için belirgin çerçeve
        : (isDark ? AppColors.darkDivider : AppColors.lightDivider); // Pasif için soluk çerçeve

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24), // Modern yüksek kavis (BorderRadius 24)
        border: Border.all(
          color: borderColor,
          width: 1, // 1px zarif kenarlık
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isActive ? colors.primary : Theme.of(context).iconTheme.color,
                  size: 26,
                ),
                const SizedBox(width: 16),
              ],
              Text(
                prayerName,
                style: AppTypography.displaySmall(
                  color: isActive ? colors.primary : Theme.of(context).textTheme.bodyLarge?.color,
                ).copyWith(fontSize: 22),
              ),
            ],
          ),
          Text(
            timeString,
            style: AppTypography.displayMedium(
              color: isActive ? colors.primary : Theme.of(context).textTheme.displayMedium?.color,
            ).copyWith(fontSize: 32),
          ),
        ],
      ),
    );
  }
}
