import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/prayer_time.dart';
import '../services/service_providers.dart';

/// Tüm veri akışını (Konum → API → Veritabanı → UI) koordine eden provider.
final prayerTimesProvider =
    AsyncNotifierProvider<PrayerTimesNotifier, PrayerTime?>(() {
  return PrayerTimesNotifier();
});

class PrayerTimesNotifier extends AsyncNotifier<PrayerTime?> {
  @override
  Future<PrayerTime?> build() async {
    return _fetchAndCacheData();
  }

  Future<PrayerTime?> _fetchAndCacheData() async {
    try {
      final localDb = ref.read(localStorageServiceProvider);
      final locationService = ref.read(locationServiceProvider);
      final apiService = ref.read(apiServiceProvider);

      final now = DateTime.now();
      final todayStr = DateFormat('yyyy-MM-dd').format(now);
      debugPrint('📅 Vakitler yükleniyor: $todayStr');

      PrayerTime? todayData;

      // 1. Cache hit: Bu ay verisi Hive'da varsa direkt al
      if (localDb.hasDataForMonth(now.year, now.month)) {
        debugPrint('✅ Cache Hit → Hive\'dan getiriliyor');
        todayData = localDb.getPrayerTimeByDate(todayStr);
      } else {
        // 2. Cache miss: Konum al → API → kaydet
        debugPrint('🌐 Cache Miss → Konum alınıyor...');
        final coord = await locationService.getCurrentLocation();
        debugPrint('📍 Konum: (${coord.latitude}, ${coord.longitude})');

        debugPrint("🌐 API'den aylık veriler çekiliyor...");
        final monthlyData = await apiService.fetchMonthlyPrayerTimes(
          latitude: coord.latitude,
          longitude: coord.longitude,
          year: now.year,
          month: now.month,
        );
        debugPrint("✅ ${monthlyData.length} günlük veri alındı.");

        await localDb.saveMonthlyData(monthlyData);
        todayData = localDb.getPrayerTimeByDate(todayStr);
      }

      debugPrint('✅ Veri hazır. UI güncelleniyor...');

      // GÖREV 1 ÇÖZÜMÜ: state'i AÇIKÇA güncelle → UI kesinlikle rebuild olur.
      // Sadece return yetmiyor; microtask/bildirim sürecindeki async gecikmeler
      // state'in loading'de kalmasına yol açabiliyordu.
      state = AsyncValue.data(todayData);

      // Bildirim kurulumunu state güncellemesinden SONRA, arka planda başlat.
      // Bu satır state'i bloke etmez; izin diyalogları açılsa bile UI zaten veriyi gösteriyor.
      if (todayData != null) {
        _scheduleNotificationsInBackground(todayData);
      }

      return todayData;
    } catch (e, st) {
      debugPrint('❌ Vakitler yüklenirken hata: $e\n$st');
      // Hatayı fırlat → Riverpod error state'e geçer → UI "Tekrar Dene" gösterir
      rethrow;
    }
  }

  /// Bildirim izin isteklerini ve zamanlamayı arka planda çalıştırır.
  /// State güncellemesini BLOKE ETMEZ.
  void _scheduleNotificationsInBackground(PrayerTime data) {
    Future(() async {
      try {
        debugPrint('🔔 Arka planda bildirim izinleri isteniyor...');
        final notifService = ref.read(notificationServiceProvider);
        await notifService.requestAllPermissions();
        await notifService.schedulePrayerNotifications(data);
        debugPrint('✅ Bildirimler zamanlandı.');
      } catch (e) {
        // Bildirim hatası UI'ı etkilemez
        debugPrint('⚠️ Bildirim kurulumu başarısız (vakitler etkilenmez): $e');
      }
    });
  }

  /// Kullanıcı "Verileri Yenile" butonuna basınca çağrılır.
  Future<void> refreshData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final localDb = ref.read(localStorageServiceProvider);
      await localDb.clearAllData();
      return _fetchAndCacheData();
    });
  }
}
