import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 6 temel kaza borcunu (Sabah, Öğle, İkindi, Akşam, Yatsı, Oruç) tutan durum sınıfı.
/// RULE (AGENTS.md): Codebase 100% English variables (e.g. yatsi instead of yatsı).
class KazaState extends Equatable {
  final int sabah;
  final int ogle;
  final int ikindi;
  final int aksam;
  final int yatsi;
  final int oruc;

  const KazaState({
    this.sabah = 0,
    this.ogle = 0,
    this.ikindi = 0,
    this.aksam = 0,
    this.yatsi = 0,
    this.oruc = 0,
  });

  KazaState copyWith({
    int? sabah,
    int? ogle,
    int? ikindi,
    int? aksam,
    int? yatsi,
    int? oruc,
  }) {
    return KazaState(
      sabah: sabah ?? this.sabah,
      ogle: ogle ?? this.ogle,
      ikindi: ikindi ?? this.ikindi,
      aksam: aksam ?? this.aksam,
      yatsi: yatsi ?? this.yatsi,
      oruc: oruc ?? this.oruc,
    );
  }

  Map<String, dynamic> toJson() => {
        'sabah': sabah,
        'ogle': ogle,
        'ikindi': ikindi,
        'aksam': aksam,
        'yatsi': yatsi,
        'oruc': oruc,
      };

  factory KazaState.fromJson(Map<String, dynamic> json) => KazaState(
        sabah: json['sabah'] as int? ?? 0,
        ogle: json['ogle'] as int? ?? 0,
        ikindi: json['ikindi'] as int? ?? 0,
        aksam: json['aksam'] as int? ?? 0,
        yatsi: json['yatsi'] as int? ?? 0,
        oruc: json['oruc'] as int? ?? 0,
      );

  @override
  List<Object?> get props => [sabah, ogle, ikindi, aksam, yatsi, oruc];
}

/// Kaza verilerini saklayan ve yöneten Riverpod Provider.
final kazaProvider = StateNotifierProvider<KazaNotifier, KazaState>((ref) {
  return KazaNotifier();
});

class KazaNotifier extends StateNotifier<KazaState> {
  static const String _key = 'kaza_state';

  KazaNotifier() : super(const KazaState()) {
    _loadState();
  }

  /// Yerel veritabanından kaza verilerini yükler
  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_key);
      if (jsonStr != null) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        state = KazaState.fromJson(map);
      }
    } catch (_) {}
  }

  /// Kaza verilerini anlık kaydeder
  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(state.toJson()));
    } catch (_) {}
  }

  /// Borç artırma
  void increment(String key) {
    switch (key) {
      case 'sabah':
        state = state.copyWith(sabah: state.sabah + 1);
        break;
      case 'ogle':
        state = state.copyWith(ogle: state.ogle + 1);
        break;
      case 'ikindi':
        state = state.copyWith(ikindi: state.ikindi + 1);
        break;
      case 'aksam':
        state = state.copyWith(aksam: state.aksam + 1);
        break;
      case 'yatsi':
        state = state.copyWith(yatsi: state.yatsi + 1);
        break;
      case 'oruc':
        state = state.copyWith(oruc: state.oruc + 1);
        break;
    }
    _saveState();
  }

  /// Borç düşürme (Minimum 0 kalacak şekilde)
  void decrement(String key) {
    switch (key) {
      case 'sabah':
        if (state.sabah > 0) state = state.copyWith(sabah: state.sabah - 1);
        break;
      case 'ogle':
        if (state.ogle > 0) state = state.copyWith(ogle: state.ogle - 1);
        break;
      case 'ikindi':
        if (state.ikindi > 0) state = state.copyWith(ikindi: state.ikindi - 1);
        break;
      case 'aksam':
        if (state.aksam > 0) state = state.copyWith(aksam: state.aksam - 1);
        break;
      case 'yatsi':
        if (state.yatsi > 0) state = state.copyWith(yatsi: state.yatsi - 1);
        break;
      case 'oruc':
        if (state.oruc > 0) state = state.copyWith(oruc: state.oruc - 1);
        break;
    }
    _saveState();
  }

  /// Borç değerini doğrudan belirleme (Manuel Klavyeden Giriş)
  void setValue(String key, int value) {
    final newValue = value < 0 ? 0 : value;
    switch (key) {
      case 'sabah':
        state = state.copyWith(sabah: newValue);
        break;
      case 'ogle':
        state = state.copyWith(ogle: newValue);
        break;
      case 'ikindi':
        state = state.copyWith(ikindi: newValue);
        break;
      case 'aksam':
        state = state.copyWith(aksam: newValue);
        break;
      case 'yatsi':
        state = state.copyWith(yatsi: newValue);
        break;
      case 'oruc':
        state = state.copyWith(oruc: newValue);
        break;
    }
    _saveState();
  }
}
