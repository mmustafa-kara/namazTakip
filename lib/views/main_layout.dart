import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/theme.dart';
import 'home_view.dart';
import 'kaza_takip_view.dart';
import 'qibla_view.dart';
import 'settings_view.dart';
import 'zikirmatik_view.dart';

/// Uygulamanın ana kabuk ekranı ve alt menü navigasyonu (Main Layout).
/// AGENTS.md: Flat Premium stil (sıfır elevation, 1px zarif üst kenarlık, Emerald vurgu).
/// OPTIMIZATIONS.md: [IndexedStack] kullanılarak sayfaların state'i korunur.
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeView(),
    QiblaView(),
    ZikirmatikView(),
    KazaTakipView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkAccentPrimary : AppColors.lightAccentPrimary;
    final textHint = isDark ? AppColors.darkTextHint : AppColors.lightTextHint;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final divider = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Sayfa durumlarını koruyarak anında geçiş sağlayan yapı
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // Flat Premium Alt Menü
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: surface,
          border: Border(
            top: BorderSide(
              color: divider,
              width: 1, // 1px zarif üst kenarlık
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: Icons.access_time_rounded,
                  activeIcon: Icons.access_time_filled_rounded,
                  label: 'Vakitler',
                  isSelected: _currentIndex == 0,
                  accentColor: accent,
                  unselectedColor: textHint,
                  onTap: () {
                    if (_currentIndex != 0) {
                      HapticFeedback.selectionClick();
                      setState(() => _currentIndex = 0);
                    }
                  },
                ),
                _NavItem(
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore_rounded,
                  label: 'Kıble',
                  isSelected: _currentIndex == 1,
                  accentColor: accent,
                  unselectedColor: textHint,
                  onTap: () {
                    if (_currentIndex != 1) {
                      HapticFeedback.selectionClick();
                      setState(() => _currentIndex = 1);
                    }
                  },
                ),
                _NavItem(
                  icon: Icons.touch_app_outlined,
                  activeIcon: Icons.touch_app_rounded,
                  label: 'Zikir',
                  isSelected: _currentIndex == 2,
                  accentColor: accent,
                  unselectedColor: textHint,
                  onTap: () {
                    if (_currentIndex != 2) {
                      HapticFeedback.selectionClick();
                      setState(() => _currentIndex = 2);
                    }
                  },
                ),
                _NavItem(
                  icon: Icons.assignment_outlined,
                  activeIcon: Icons.assignment_rounded,
                  label: 'Kaza',
                  isSelected: _currentIndex == 3,
                  accentColor: accent,
                  unselectedColor: textHint,
                  onTap: () {
                    if (_currentIndex != 3) {
                      HapticFeedback.selectionClick();
                      setState(() => _currentIndex = 3);
                    }
                  },
                ),
                _NavItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings_rounded,
                  label: 'Ayarlar',
                  isSelected: _currentIndex == 4,
                  accentColor: accent,
                  unselectedColor: textHint,
                  onTap: () {
                    if (_currentIndex != 4) {
                      HapticFeedback.selectionClick();
                      setState(() => _currentIndex = 4);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Özel Flat Premium Navigasyon Elemanı
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final Color accentColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.accentColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? accentColor : unselectedColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: isSelected
                  ? AppTypography.labelMedium(color: color)
                  : AppTypography.labelSmall(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
