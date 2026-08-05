import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_service.dart';
import 'local_storage_service.dart';
import 'location_service.dart';
import 'notification_service.dart';
import 'qibla_service.dart';

/// Tüm servislerin bağımlılık enjeksiyonunu (Dependency Injection) yöneten Riverpod Provider'ları.
/// View/ViewModel katmanları servisleri doğrudan instance oluşturmak yerine bu provider'lardan okumalıdır.

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final qiblaServiceProvider = Provider<QiblaService>((ref) {
  return QiblaService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
