import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Konum (Enlem, Boylam) verilerini tutan güvenli Record tipi.
typedef Coordinate = ({double latitude, double longitude});

/// Manuel Konum Detay Tipi
typedef CustomLocationData = ({
  String name,
  String city,
  String district,
  double latitude,
  double longitude
});

/// Kullanıcının konumunu (GPS veya Manuel Konum) alan servis.
/// AGENTS.md: İzin reddedilirse uygulamanın çökmemesi için sağlam bir B planı (Fallback) içermelidir.
class LocationService {
  // İzin verilmezse veya hata olursa kullanılacak nihai B Planı: İnegöl, Bursa koordinatları
  static const Coordinate _fallbackCoordinate = (latitude: 40.08, longitude: 29.51);

  static const String _keyCustomEnabled = 'custom_location_enabled';
  static const String _keyCustomCity = 'custom_location_city';
  static const String _keyCustomDistrict = 'custom_location_district';
  static const String _keyCustomLat = 'custom_location_lat';
  static const String _keyCustomLng = 'custom_location_lng';

  /// Manuel (Custom) konum kayıtlı ve aktif mi kontrol eder.
  Future<CustomLocationData?> getCustomLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool(_keyCustomEnabled) ?? false;
      if (isEnabled) {
        final city = prefs.getString(_keyCustomCity) ?? '';
        final district = prefs.getString(_keyCustomDistrict) ?? '';
        final lat = prefs.getDouble(_keyCustomLat);
        final lng = prefs.getDouble(_keyCustomLng);

        if (lat != null && lng != null && city.isNotEmpty) {
          final name = district.isNotEmpty ? '$district, $city' : city;
          return (
            name: name,
            city: city,
            district: district,
            latitude: lat,
            longitude: lng,
          );
        }
      }
    } catch (e) {
      debugPrint('⚠️ Custom location okuma hatası: $e');
    }
    return null;
  }

  /// Kullanıcının seçtiği il/ilçeyi manuel konum olarak kaydeder.
  Future<void> saveCustomLocation({
    required String city,
    required String district,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyCustomEnabled, true);
      await prefs.setString(_keyCustomCity, city);
      await prefs.setString(_keyCustomDistrict, district);
      await prefs.setDouble(_keyCustomLat, latitude);
      await prefs.setDouble(_keyCustomLng, longitude);
      debugPrint('📍 Manuel konum kaydedildi: $district, $city ($latitude, $longitude)');
    } catch (e) {
      debugPrint('❌ Manuel konum kaydetme hatası: $e');
    }
  }

  /// Manuel konumu temizler ve otomatik GPS moduna geri döner.
  Future<void> clearCustomLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyCustomEnabled, false);
      await prefs.remove(_keyCustomCity);
      await prefs.remove(_keyCustomDistrict);
      await prefs.remove(_keyCustomLat);
      await prefs.remove(_keyCustomLng);
      debugPrint('🔄 Manuel konum temizlendi, Otomatik GPS moduna geçildi.');
    } catch (e) {
      debugPrint('❌ Manuel konum temizleme hatası: $e');
    }
  }

  /// Cihazın anlık konumunu döndürür.
  /// GÖREV 2 MANTIĞI: Eğer manuel (custom) konum varsa, GPS'i (Geolocator)
  /// HİÇ ÇALIŞTIRMADAN direkt kaydedilen manuel konumu döndürür!
  Future<Coordinate> getCurrentLocation() async {
    // 0. Öncelik: Manuel Konum var mı?
    final customLoc = await getCustomLocation();
    if (customLoc != null) {
      debugPrint('📍 GÖREV 2: Manuel Konum Kullanılıyor: ${customLoc.name} (GPS pas geçildi)');
      return (latitude: customLoc.latitude, longitude: customLoc.longitude);
    }

    // Manuel konum yoksa Otomatik GPS Akışı:
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // 1. Konum servisleri açık mı?
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _getLastKnownOrFallback();
      }

      // 2. İzin kontrolü
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _getLastKnownOrFallback();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _getLastKnownOrFallback();
      }

      // 3. Konumu Al
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 5000,
        ),
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('Konum 5sn içinde alınamadı'),
      );

      final coord = (latitude: pos.latitude, longitude: pos.longitude);
      await _saveLastLocation(coord);
      return coord;
    } catch (e) {
      return _getLastKnownOrFallback();
    }
  }

  /// Eğer anlık konum alınamazsa, önbellekteki son konumu veya İnegöl'ü döner.
  Future<Coordinate> _getLastKnownOrFallback() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble('last_lat');
      final lng = prefs.getDouble('last_lng');

      if (lat != null && lng != null) {
        return (latitude: lat, longitude: lng);
      }
    } catch (_) {}

    return _fallbackCoordinate;
  }

  /// Başarılı alınan bir konumu önbelleğe kaydeder.
  Future<void> _saveLastLocation(Coordinate coord) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('last_lat', coord.latitude);
      await prefs.setDouble('last_lng', coord.longitude);
    } catch (_) {}
  }
}
