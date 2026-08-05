import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/prayer_time.dart';
import '../services/service_providers.dart';

/// Tüm veri akışını (Konum alma -> API çağrısı -> Veritabanına kaydetme -> UI'a iletme)
/// koordine eden ana ViewModel provider'ımız.
final prayerTimesProvider = AsyncNotifierProvider<PrayerTimesNotifier, PrayerTime?>(() {
  return PrayerTimesNotifier();
});

class PrayerTimesNotifier extends AsyncNotifier<PrayerTime?> {
  @override
  Future<PrayerTime?> build() async {
    // Uygulama ilk açıldığında çalışacak metot
    return _fetchAndCacheData();
  }

  /// AGENTS.md ve OPTIMIZATIONS.md kısıtlamalarına tam uyumlu akış:
  /// 1. Bugünün tarihini al.
  /// 2. İçinde bulunduğumuz ay için Hive'da veri var mı kontrol et.
  /// 3. Varsa (Cache Hit): Hemen Hive'dan bugünü getir.
  /// 4. Yoksa (Cache Miss): Önce konumu (LocationService) bul.
  /// 5. Bulunan konumla API'ye (ApiService) aylık istek at.
  /// 6. Gelen aylık veriyi Hive'a (LocalStorageService) kaydet.
  /// 7. Bugünün verisini UI'a dön.
  Future<PrayerTime?> _fetchAndCacheData() async {
    try {
      final localDb = ref.read(localStorageServiceProvider);
      final locationService = ref.read(locationServiceProvider);
      final apiService = ref.read(apiServiceProvider);

      final now = DateTime.now();
      // API'den "YYYY-MM-DD" formatında çevirmiştik, sorguyu aynı formatta yapıyoruz
      final todayStr = DateFormat('yyyy-MM-dd').format(now);

      debugPrint('📍 Vakitler yükleniyor... ($todayStr)');

      // 1. Veritabanı kontrolü (Sadece bu ay için)
      final hasData = localDb.hasDataForMonth(now.year, now.month);

      PrayerTime? todayData;

      if (hasData) {
        // Offline-first: Ağ isteği atmadan direkt veritabanından getir
        debugPrint('✅ Cache Hit: Veritabanından getiriliyor...');
        todayData = localDb.getPrayerTimeByDate(todayStr);
      } else {
        // 2. Veri yok, o zaman konumu bulalım (GPS izni yoksa B planı İstanbul gelecek)
        debugPrint('🌐 Cache Miss: Konum alınıyor...');
        final coord = await locationService.getCurrentLocation();
        debugPrint('📍 Konum alındı: (${coord.latitude}, ${coord.longitude})');

        // 3. Bulunan koordinatla API'den o ayın verilerini çek
        debugPrint('🌐 API\'den aylık veriler çekiliyor...');
        final monthlyData = await apiService.fetchMonthlyPrayerTimes(
          latitude: coord.latitude,
          longitude: coord.longitude,
          year: now.year,
          month: now.month,
        );
        debugPrint('✅ API\'den ${monthlyData.length} günlük veri alındı.');

        // 4. Gelecek kullanımlar için (offline dahil) veritabanına kaydet
        await localDb.saveMonthlyData(monthlyData);

        // 5. Kaydettiğimiz veritabanından bugünü çek
        todayData = localDb.getPrayerTimeByDate(todayStr);
      }

      // Bugüne ait vakitler geldiyse akıllı bildirim algoritmasını kur
      if (todayData != null) {
        debugPrint('🔔 Bildirim izinleri isteniyor...');
        final notifService = ref.read(notificationServiceProvider);

        // ── Sıralı İzin Zinciri (Sequential Permission Chain) ──
        // Konum izni yukarıda zaten sonuçlandı (getCurrentLocation await ile bitti).
        // Şimdi bildirim ve hassas alarm izinlerini güvenle isteyebiliriz.
        // Bu sıralama "Can request only one set of permissions at a time" hatasını önler.
        try {
          await notifService.requestAllPermissions();
          await notifService.schedulePrayerNotifications(todayData);
          debugPrint('✅ Bildirimler zamanlandı.');
        } catch (notifError) {
          // Bildirim kurulumu başarısız olsa bile vakitleri göstermeye devam et
          debugPrint('⚠️ Bildirim kurulumu başarısız (vakitler etkilenmez): $notifError');
        }
      } else {
        debugPrint('⚠️ Bugüne ait vakit verisi bulunamadı: $todayStr');
      }

      debugPrint('✅ Vakitler başarıyla yüklendi.');
      return todayData;
    } catch (e, stackTrace) {
      debugPrint('❌ Vakitler yüklenirken hata: $e');
      debugPrint('📋 StackTrace: $stackTrace');
      // Hatayı Riverpod'a fırlat → UI'da Error State gösterilsin, sonsuz loading olmasın
      rethrow;
    }
  }

  /// Kullanıcı manuel olarak konumu güncelleyip (örneğin ayarlar sayfasından)
  /// veya internet bağlantısı geldiğinde veriyi tazelemek isterse çağrılır.
  Future<void> refreshData() async {
    // Önce loading durumuna çekerek UI'a haber veriyoruz
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final localDb = ref.read(localStorageServiceProvider);
      // Eski verileri temizleyip sıfırdan çekmeye zorluyoruz
      await localDb.clearAllData();
      return _fetchAndCacheData();
    });
  }
}
