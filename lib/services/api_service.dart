import 'dart:isolate';
import 'package:dio/dio.dart';
import '../models/prayer_time.dart';

/// Aladhan API ile iletişim kuran servis.
/// OPTIMIZATIONS.md: Ağır JSON parse işlemleri ana thread'i bloklamamak için [Isolate.run] ile arka planda yapılır.
class ApiService {
  final Dio _dio;

  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'http://api.aladhan.com/v1',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  /// Belirtilen yıl ve ay için namaz vakitlerini çeker.
  /// method: 13 -> Diyanet İşleri Başkanlığı hesaplama yöntemi
  Future<List<PrayerTime>> fetchMonthlyPrayerTimes({
    required double latitude,
    required double longitude,
    required int year,
    required int month,
  }) async {
    try {
      final response = await _dio.get(
        '/calendar/$year/$month',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'method': 13, 
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final dataList = response.data['data'] as List<dynamic>;
        
        // UI thread'ini dondurmamak için parse işlemini ayrı bir Isolate (iş parçacığı) üzerinde yapıyoruz.
        return await Isolate.run(() => _parsePrayerTimes(dataList));
      } else {
        throw Exception('API yanıt hatası. Kod: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Hata yönetimi (Network, Timeout vs.)
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Bağlantı zaman aşımına uğradı. İnternetinizi kontrol edin.');
      }
      throw Exception('Ağ Hatası: ${e.message}');
    } catch (e) {
      throw Exception('Namaz vakitleri çekilirken beklenmeyen hata: $e');
    }
  }

  /// Bu metod [Isolate] içinde çalışacağı için statik olarak tanımlanmıştır.
  /// Gelen dynamic listeyi [PrayerTime] listesine dönüştürür.
  static List<PrayerTime> _parsePrayerTimes(List<dynamic> jsonList) {
    return jsonList
        .map((e) => PrayerTime.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
