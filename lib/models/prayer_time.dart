import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

/// Aylık namaz vakitleri verisini temsil eden model sınıfı.
/// Aladhan API'den dönen karmaşık JSON bu modele dönüştürülür.
class PrayerTime extends Equatable {
  /// YYYY-MM-DD formatında tarih (kolay sorgulama için)
  final String date;
  final String imsak;
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  const PrayerTime({
    required this.date,
    required this.imsak,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  /// API'den gelen karmaşık JSON verisini ayrıştırır.
  /// (Timings içindeki "05:14 (EEST)" gibi formatları temizler)
  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    String cleanTime(String time) => time.split(' ').first;

    final timings = json['timings'] as Map<String, dynamic>;
    final dateObj = json['date'] as Map<String, dynamic>;
    final gregorian = dateObj['gregorian'] as Map<String, dynamic>;
    
    // API "DD-MM-YYYY" formatında dönüyor, biz "YYYY-MM-DD" yapıyoruz
    final dateString = gregorian['date'] as String; 
    final parts = dateString.split('-');
    final formattedDate = '${parts[2]}-${parts[1]}-${parts[0]}';

    return PrayerTime(
      date: formattedDate,
      imsak: cleanTime(timings['Imsak']),
      fajr: cleanTime(timings['Fajr']),
      sunrise: cleanTime(timings['Sunrise']),
      dhuhr: cleanTime(timings['Dhuhr']),
      asr: cleanTime(timings['Asr']),
      maghrib: cleanTime(timings['Maghrib']),
      isha: cleanTime(timings['Isha']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'imsak': imsak,
      'fajr': fajr,
      'sunrise': sunrise,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
    };
  }

  @override
  List<Object?> get props => [
        date,
        imsak,
        fajr,
        sunrise,
        dhuhr,
        asr,
        maghrib,
        isha,
      ];
}

/// Hive veritabanı için manuel TypeAdapter (Code generation kullanmıyoruz).
class PrayerTimeAdapter extends TypeAdapter<PrayerTime> {
  @override
  final int typeId = 0;

  @override
  PrayerTime read(BinaryReader reader) {
    return PrayerTime(
      date: reader.readString(),
      imsak: reader.readString(),
      fajr: reader.readString(),
      sunrise: reader.readString(),
      dhuhr: reader.readString(),
      asr: reader.readString(),
      maghrib: reader.readString(),
      isha: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, PrayerTime obj) {
    writer.writeString(obj.date);
    writer.writeString(obj.imsak);
    writer.writeString(obj.fajr);
    writer.writeString(obj.sunrise);
    writer.writeString(obj.dhuhr);
    writer.writeString(obj.asr);
    writer.writeString(obj.maghrib);
    writer.writeString(obj.isha);
  }
}
