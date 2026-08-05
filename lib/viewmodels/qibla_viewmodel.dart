import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/service_providers.dart';

/// Kullanıcının anlık GPS konumuna göre Kâbe açısını (North'a göre bearing) veren FutureProvider.
final qiblaBearingProvider = FutureProvider<double>((ref) async {
  final locationService = ref.read(locationServiceProvider);
  final qiblaService = ref.read(qiblaServiceProvider);
  final coord = await locationService.getCurrentLocation();
  return qiblaService.calculateQiblaBearing(coord);
});

/// Cihazın pusula (manyetometre) sensöründen gelen 60 FPS açı akışını (Stream) sağlayan Provider.
final compassStreamProvider = StreamProvider<CompassEvent?>((ref) {
  final qiblaService = ref.read(qiblaServiceProvider);
  return qiblaService.compassStream ?? const Stream.empty();
});
