import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Zikir sayısını yöneten ve SharedPreferences ile cihazda saklayan Provider.
final zikirCountProvider = StateNotifierProvider<ZikirNotifier, int>((ref) {
  return ZikirNotifier();
});

class ZikirNotifier extends StateNotifier<int> {
  static const String _key = 'zikir_count';

  ZikirNotifier() : super(0) {
    _loadCount();
  }

  /// Cihaza kaydedilmiş zikir sayısını okur
  Future<void> _loadCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getInt(_key) ?? 0;
    } catch (_) {}
  }

  /// Zikir sayısını 1 artırır ve yerel veritabanına kaydeder
  Future<void> increment() async {
    state = state + 1;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_key, state);
    } catch (_) {}
  }

  /// Sayacı 0'lar
  Future<void> reset() async {
    state = 0;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_key, 0);
    } catch (_) {}
  }
}
