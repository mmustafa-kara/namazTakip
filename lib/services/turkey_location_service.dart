import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';

class DistrictModel {
  final String code;
  final String name;

  const DistrictModel({
    required this.code,
    required this.name,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      code: (json['ilce_kodu'] ?? '').toString(),
      name: (json['ilce_adi'] ?? '').toString(),
    );
  }
}

class ProvinceModel {
  final String name;
  final String plateCode;
  final List<DistrictModel> districts;

  const ProvinceModel({
    required this.name,
    required this.plateCode,
    required this.districts,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    final rawDistricts = json['ilceler'] as List<dynamic>? ?? [];
    return ProvinceModel(
      name: (json['il_adi'] ?? '').toString(),
      plateCode: (json['plaka_kodu'] ?? '').toString(),
      districts: rawDistricts
          .map((d) => DistrictModel.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Türkiye 81 İl ve 922 İlçesini `assets/data/turkiye_il_ilce.json` dosyasından okuyan servis.
class TurkeyLocationService {
  static final TurkeyLocationService _instance = TurkeyLocationService._internal();
  factory TurkeyLocationService() => _instance;
  TurkeyLocationService._internal();

  List<ProvinceModel> _provinces = [];
  bool _isLoaded = false;

  /// Türkiye iller listesi
  List<ProvinceModel> get provinces => _provinces;

  /// JSON dosyasını yerel asset'ten yükler
  Future<List<ProvinceModel>> loadProvinces() async {
    if (_isLoaded && _provinces.isNotEmpty) {
      return _provinces;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/turkiye_il_ilce.json');
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

      _provinces = jsonList
          .map((item) => ProvinceModel.fromJson(item as Map<String, dynamic>))
          .toList();

      _isLoaded = true;
      debugPrint('✅ Türkiye il/ilce JSON yüklendi: ${_provinces.length} il');
      return _provinces;
    } catch (e) {
      debugPrint('❌ Türkiye il/ilce JSON okuma hatası: $e');
      return [];
    }
  }

  /// Seçilen ilçe ve il için hassas koordinat (Enlem, Boylam) bulur.
  /// geocoding paketini kullanır; hata verirse varsayılan Türkiye merkez koordinatlarını döner.
  Future<({double latitude, double longitude})> getCoordinatesForDistrict({
    required String provinceName,
    required String districtName,
  }) async {
    try {
      final searchQuery = '$districtName, $provinceName, Turkey';
      debugPrint('🌐 Geocoding aranıyor: $searchQuery');

      final locations = await locationFromAddress(searchQuery).timeout(
        const Duration(seconds: 4),
      );

      if (locations.isNotEmpty) {
        final loc = locations.first;
        debugPrint('📍 Geocoding bulundu: (${loc.latitude}, ${loc.longitude})');
        return (latitude: loc.latitude, longitude: loc.longitude);
      }
    } catch (e) {
      debugPrint('⚠️ Geocoding başarısız ($e), il varsayılanına düşülüyor.');
    }

    // Geocoding başarısız olursa güvenli fallback
    return (latitude: 39.9334, longitude: 32.8597); // Ankara merkez fallback
  }
}
