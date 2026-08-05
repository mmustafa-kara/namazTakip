import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Konum (Enlem, Boylam) verilerini tutan güvenli Record tipi.
/// Geolocator paketindeki değişikliklerden (ör: Position sınıfındaki zorunlu alanlar)
/// etkilenmemek için kendi veri tipimizi kullanıyoruz.
typedef Coordinate = ({double latitude, double longitude});

/// Kullanıcının konumunu (GPS) alan servis.
/// AGENTS.md: İzin reddedilirse uygulamanın çökmemesi için sağlam bir B planı (Fallback) içermelidir.
class LocationService {
  // İzin verilmezse veya hata olursa kullanılacak nihai B Planı: İnegöl, Bursa koordinatları
  static const Coordinate _fallbackCoordinate = (latitude: 40.08, longitude: 29.51);

  /// Cihazın anlık konumunu döndürür. İzin yoksa veya kapalıysa son bilinen konumu
  /// veya varsayılan İstanbul konumunu döndürür.
  Future<Coordinate> getCurrentLocation() async {
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
      // OPTIMIZATIONS.md: Namaz vakitleri için santimlik GPS hassasiyetine gerek yoktur.
      // Bataryayı korumak için accuracy: low ve distanceFilter kullanıyoruz.
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 5000, // 5km yer değiştirmeden yeni konum tetiklenmez
        ),
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('Konum 5sn içinde alınamadı'),
      );
      
      final coord = (latitude: pos.latitude, longitude: pos.longitude);
      
      // Başarılı konumu daha sonra B planı olarak kullanmak üzere kaydediyoruz
      await _saveLastLocation(coord);
      return coord;
    } catch (e) {
      // Herhangi bir exception durumunda güvenli dönüş
      return _getLastKnownOrFallback();
    }
  }

  /// Eğer anlık konum alınamazsa, cihazın önbellekteki (SharedPreferences) 
  /// son başarılı konumunu, o da yoksa İstanbul'u döner.
  Future<Coordinate> _getLastKnownOrFallback() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble('last_lat');
      final lng = prefs.getDouble('last_lng');
      
      if (lat != null && lng != null) {
        return (latitude: lat, longitude: lng);
      }
    } catch (_) {
      // SharedPreferences hatası yoksayılır
    }
    
    return _fallbackCoordinate;
  }
  
  /// Başarılı alınan bir konumu önbelleğe kaydeder.
  Future<void> _saveLastLocation(Coordinate coord) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('last_lat', coord.latitude);
      await prefs.setDouble('last_lng', coord.longitude);
    } catch (_) {
      // Yoksay
    }
  }
}
