import 'package:intl/intl.dart';
import '../models/prayer_time.dart';

/// Namaz vakitleri üzerinde saat hesaplamaları yapan yardımcı sınıf.
/// AGENTS.md: İş mantığı View'da değil, bu yardımcı sınıfta bulunur.
class PrayerScheduleHelper {
  /// PrayerTime model'indeki "HH:mm" string'ini bugünün DateTime'ına çevirir.
  static DateTime _toDateTime(String timeStr) {
    final now = DateTime.now();
    final parts = timeStr.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  /// Türkçe isim, model alanı ve ikonunu birleştiren veri sınıfı.
  static List<PrayerEntry> getPrayerEntries(PrayerTime p) => [
        PrayerEntry(
          name: 'İmsak',
          time: p.imsak,
          dateTime: _toDateTime(p.imsak),
        ),
        PrayerEntry(
          name: 'Güneş',
          time: p.sunrise,
          dateTime: _toDateTime(p.sunrise),
        ),
        PrayerEntry(
          name: 'Öğle',
          time: p.dhuhr,
          dateTime: _toDateTime(p.dhuhr),
        ),
        PrayerEntry(
          name: 'İkindi',
          time: p.asr,
          dateTime: _toDateTime(p.asr),
        ),
        PrayerEntry(
          name: 'Akşam',
          time: p.maghrib,
          dateTime: _toDateTime(p.maghrib),
        ),
        PrayerEntry(
          name: 'Yatsı',
          time: p.isha,
          dateTime: _toDateTime(p.isha),
        ),
      ];

  /// Şu anki aktif vaktin index'ini döndürür.
  /// Örn: Saat 14:30 ise Öğle (index 2) aktif, bir sonraki İkindi (index 3)'dir.
  static int getActiveIndex(List<PrayerEntry> entries) {
    final now = DateTime.now();
    // Vakitleri tersine tarayarak "geçen son vakit" = aktif vakit mantığını uygula
    for (int i = entries.length - 1; i >= 0; i--) {
      if (now.isAfter(entries[i].dateTime)) {
        return i;
      }
    }
    // Gece yarısından sonra, İmsak'tan önce: Yatsı hâlâ aktif sayılır
    return entries.length - 1;
  }

  /// Bir sonraki vaktin DateTime'ını döndürür (CountdownTimer'a beslenir).
  static DateTime getNextPrayerTime(List<PrayerEntry> entries) {
    final now = DateTime.now();
    for (final entry in entries) {
      if (entry.dateTime.isAfter(now)) {
        return entry.dateTime;
      }
    }
    // Tüm vakitler geçtiyse yarın ilk vakit (İmsak +24 saat)
    return entries.first.dateTime.add(const Duration(days: 1));
  }

  /// Bir sonraki vaktin Türkçe adını döndürür.
  static String getNextPrayerName(List<PrayerEntry> entries) {
    final now = DateTime.now();
    for (final entry in entries) {
      if (entry.dateTime.isAfter(now)) {
        return entry.name;
      }
    }
    return entries.first.name;
  }

  /// Bugünün tarihini Türkçe formatlar. Örn: "4 Ağustos 2026, Salı"
  static String formatTurkishDate(DateTime dt) {
    return DateFormat('d MMMM yyyy, EEEE', 'tr_TR').format(dt);
  }
}

/// Tek bir namaz vakti girişini temsil eden basit veri sınıfı.
class PrayerEntry {
  final String name;
  final String time;
  final DateTime dateTime;

  const PrayerEntry({
    required this.name,
    required this.time,
    required this.dateTime,
  });
}
