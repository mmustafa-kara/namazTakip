import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart';

/// Pusula ve Kıble hesaplamalarını yöneten servis.
class QiblaService {
  // Mekke (Kabe) Koordinatları
  static const double _kaabaLat = 21.422487;
  static const double _kaabaLng = 39.826206;

  /// Cihazın pusula (manyetometre) sensöründen gelen verileri dinler.
  /// (Kuzey'e göre mevcut açı). Cihazda sensör yoksa null dönebilir.
  Stream<CompassEvent>? get compassStream => FlutterCompass.events;

  /// Kullanıcının mevcut konumuna göre Kabe'ye olan açıyı (Bearing/Heading) hesaplar.
  /// [Geolocator] kütüphanesinin hazır hesaplama metodunu kullanıyoruz.
  double calculateQiblaBearing(Coordinate currentCoordinate) {
    return Geolocator.bearingBetween(
      currentCoordinate.latitude,
      currentCoordinate.longitude,
      _kaabaLat,
      _kaabaLng,
    );
  }
}
