import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme.dart';
import '../viewmodels/kaza_viewmodel.dart';

/// Kaza Namazı ve Oruç Takip Ekranı (Faz 7).
/// AGENTS.md: ConsumerWidget, Flat Premium stil, <200 satır view sınırı.
/// OPTIMIZATIONS.md: [select] kullanılarak yalnızca değeri değişen kart rebuild edilir.
class KazaTakipView extends StatelessWidget {
  const KazaTakipView({super.key});

  static const List<_KazaItem> _items = [
    _KazaItem(
      key: 'sabah',
      title: 'Sabah Namazı',
      icon: Icons.wb_twilight_rounded,
    ),
    _KazaItem(key: 'ogle', title: 'Öğle Namazı', icon: Icons.wb_sunny_rounded),
    _KazaItem(
      key: 'ikindi',
      title: 'İkindi Namazı',
      icon: Icons.wb_sunny_outlined,
    ),
    _KazaItem(
      key: 'aksam',
      title: 'Akşam Namazı',
      icon: Icons.nights_stay_outlined,
    ),
    _KazaItem(
      key: 'yatsi',
      title: 'Yatsı Namazı',
      icon: Icons.nights_stay_rounded,
    ),
    _KazaItem(
      key: 'oruc',
      title: 'Kaza Orucu',
      icon: Icons.calendar_today_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textHint = isDark ? AppColors.darkTextHint : AppColors.lightTextHint;

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
                'Kaza Takibi',
                style: AppTypography.headlineLarge(color: textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                'Kaza namazlarınızı takip edebilirsiniz',
                style: AppTypography.bodySmall(color: textHint),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _KazaCard(item: _items[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KazaItem {
  final String key;
  final String title;
  final IconData icon;

  const _KazaItem({required this.key, required this.title, required this.icon});
}

/// OPTIMIZATIONS.md: Sadece ilgili kartın sayacı [ref.watch(select)] ile izole edilir
class _KazaCard extends ConsumerWidget {
  final _KazaItem item;

  const _KazaCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark
        ? AppColors.darkAccentPrimary
        : AppColors.lightAccentPrimary;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final divider = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    final count = ref.watch(
      kazaProvider.select((s) {
        switch (item.key) {
          case 'sabah':
            return s.sabah;
          case 'ogle':
            return s.ogle;
          case 'ikindi':
            return s.ikindi;
          case 'aksam':
            return s.aksam;
          case 'yatsi':
            return s.yatsi;
          case 'oruc':
            return s.oruc;
          default:
            return 0;
        }
      }),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: divider, width: 1),
      ),
      child: Row(
        children: [
          Icon(item.icon, size: 20, color: accent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.headlineSmall(
                color: textPrimary,
              ).copyWith(fontSize: 14),
            ),
          ),
          const SizedBox(width: 6),
          // Tıklanabilir Manuel Düzenleme Butonu (Flat Premium)
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              _showEditKazaDialog(context, ref, item, count);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: surface2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: divider, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$count',
                    style: AppTypography.headlineMedium(
                      color: textPrimary,
                    ).copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.edit_rounded,
                    size: 12,
                    color: accent.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                icon: Icons.remove_rounded,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref.read(kazaProvider.notifier).decrement(item.key);
                },
                accentColor: accent,
                surfaceColor: surface2,
                dividerColor: divider,
              ),
              const SizedBox(width: 6),
              _ActionButton(
                icon: Icons.add_rounded,
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.read(kazaProvider.notifier).increment(item.key);
                },
                accentColor: accent,
                surfaceColor: surface2,
                dividerColor: divider,
                isPrimary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditKazaDialog(
    BuildContext context,
    WidgetRef ref,
    _KazaItem item,
    int currentCount,
  ) {
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
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final divider = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    final controller = TextEditingController(text: '$currentCount');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          backgroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: divider, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(item.icon, size: 20, color: accent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${item.title} Kaza Sayısı',
                        style: AppTypography.headlineSmall(color: textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  style: AppTypography.displaySmall(
                    color: textPrimary,
                  ).copyWith(fontSize: 22),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: surface2,
                    hintText: '0',
                    hintStyle: AppTypography.displaySmall(
                      color: textSecondary,
                    ).copyWith(fontSize: 22),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: divider, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: divider, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: accent, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(dialogContext).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: surface2,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: divider, width: 1),
                        ),
                        child: Text(
                          'İptal',
                          style: AppTypography.labelMedium(
                            color: textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        final val = int.tryParse(controller.text) ?? 0;
                        HapticFeedback.mediumImpact();
                        ref.read(kazaProvider.notifier).setValue(item.key, val);
                        Navigator.of(dialogContext).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: accent, width: 1),
                        ),
                        child: Text(
                          'Kaydet',
                          style: AppTypography.labelLarge(color: accent),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color accentColor;
  final Color surfaceColor;
  final Color dividerColor;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.accentColor,
    required this.surfaceColor,
    required this.dividerColor,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isPrimary ? accentColor.withValues(alpha: 0.15) : surfaceColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isPrimary
                ? accentColor.withValues(alpha: 0.5)
                : dividerColor,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isPrimary ? accentColor : Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
