import 'package:hive_flutter/hive_flutter.dart';
import '../models/prayer_time.dart';

/// Hive yerel veritabanı işlemlerini yöneten servis sınıfı.
/// Offline-First mimari prensibine göre (AGENTS.md) UI veriyi her zaman buradan okumalıdır.
class LocalStorageService {
  static const String _boxName = 'prayer_times_box';

  /// Veritabanını başlatır ve TypeAdapter'ları kaydeder.
  /// (Uygulama açılırken main.dart içerisinde çağrılmalıdır)
  Future<void> init() async {
    try {
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(PrayerTimeAdapter());
      }
      await Hive.openBox<PrayerTime>(_boxName);
    } catch (e) {
      throw Exception('Yerel veritabanı başlatılamadı: $e');
    }
  }

  /// Aylık vakitleri toplu olarak (batch) veritabanına yazar.
  /// Performans için put() döngüsü yerine putAll() kullanılmıştır (OPTIMIZATIONS.md).
  Future<void> saveMonthlyData(List<PrayerTime> times) async {
    try {
      final box = Hive.box<PrayerTime>(_boxName);
      
      // Key olarak tarihi kullanarak bir Map oluşturuyoruz ("YYYY-MM-DD" -> PrayerTime)
      final Map<String, PrayerTime> entries = {
        for (var time in times) time.date: time
      };
      
      await box.putAll(entries);
    } catch (e) {
      throw Exception('Veriler kaydedilirken hata oluştu: $e');
    }
  }

  /// YYYY-MM-DD formatında verilen günün verisini getirir.
  /// Eğer o güne ait veri yoksa null döner.
  PrayerTime? getPrayerTimeByDate(String date) {
    try {
      final box = Hive.box<PrayerTime>(_boxName);
      return box.get(date);
    } catch (e) {
      // Offline okuma hatası
      return null; 
    }
  }

  /// Veritabanında belirtilen yıl ve aya ait kayıtlı veri olup olmadığını kontrol eder.
  /// API'ye gereksiz istek atmamak için (Cache hit check).
  bool hasDataForMonth(int year, int month) {
    try {
      final box = Hive.box<PrayerTime>(_boxName);
      final monthStr = month.toString().padLeft(2, '0');
      final searchPattern = '$year-$monthStr'; // Örn: "2023-10"
      
      // Kayıtlı key'ler içerisinde bu ayla başlayan var mı bakıyoruz
      return box.keys.any((key) => key.toString().startsWith(searchPattern));
    } catch (e) {
      return false;
    }
  }

  /// Box'ı tamamen temizler (Gerekirse kullanıcı ayarlarından verileri silmek için)
  Future<void> clearAllData() async {
    final box = Hive.box<PrayerTime>(_boxName);
    await box.clear();
  }
}
