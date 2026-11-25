import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import '../models/administrative_unit.dart';

abstract class AdministrativeRepository {
  Future<List<AdministrativeUnit>> getProvinces({String? query});
  Future<List<AdministrativeUnit>> getWards(String provinceCode, {String? query});
  AdministrativeUnit? getProvinceByCode(String code);
  AdministrativeUnit? getWardByCode(String code);
  String formatLocation(String? provinceCode, String? wardCode);
}

/// Repository đơn vị hành chính Việt Nam nạp trực tiếp từ bộ dữ liệu chuẩn
/// `assets/data/vietnam_administrative_units.json` (63 tỉnh/thành, ~700 quận/huyện, >10.000 xã/phường).
/// Hỗ trợ tìm kiếm không dấu/có dấu, tìm theo quận huyện, và đồng bộ mã chi nhánh Spa.
class MockAdministrativeRepository implements AdministrativeRepository {
  static List<AdministrativeUnit>? _cachedProvinces;
  static Map<String, List<AdministrativeUnit>>? _cachedWardsByProvince;
  static Map<String, AdministrativeUnit>? _cachedProvinceByCode;
  static Map<String, AdministrativeUnit>? _cachedWardByCode;
  static bool _isLoading = false;

  void _ensureSyncLoaded() {
    if (_cachedProvinces != null) return;
    try {
      final file = File('assets/data/vietnam_administrative_units.json');
      if (file.existsSync()) {
        final jsonStr = file.readAsStringSync();
        _parseJson(jsonStr);
      }
    } catch (_) {}
  }

  Future<void> _ensureLoaded() async {
    if (_cachedProvinces != null) return;
    if (_isLoading) {
      while (_cachedProvinces == null) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
      return;
    }

    _isLoading = true;
    try {
      String jsonStr;
      try {
        jsonStr = await rootBundle.loadString('assets/data/vietnam_administrative_units.json');
      } catch (_) {
        final file = File('assets/data/vietnam_administrative_units.json');
        if (file.existsSync()) {
          jsonStr = await file.readAsString();
        } else {
          rethrow;
        }
      }
      _parseJson(jsonStr);
    } finally {
      _isLoading = false;
    }
  }

  static void _parseJson(String jsonStr) {
    if (_cachedProvinces != null) return;

    final List<dynamic> data = jsonDecode(jsonStr);
    final List<AdministrativeUnit> provinces = [];
    final Map<String, List<AdministrativeUnit>> wardsByProv = {};
    final Map<String, AdministrativeUnit> provinceByCode = {};
    final Map<String, AdministrativeUnit> wardByCode = {};

    for (final p in data) {
      final pId = p['id'] as String;
      final pCode = p['code'] as String? ?? pId;
      final pName = p['name'] as String;
      final pAliases = (p['aliases'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();

      final provUnit = AdministrativeUnit(
        code: pCode,
        name: pName,
        type: AdministrativeType.province,
        aliases: pAliases,
      );

      provinces.add(provUnit);
      provinceByCode[pCode] = provUnit;
      provinceByCode[pId] = provUnit;
      for (final alias in pAliases) {
        provinceByCode[alias] = provUnit;
      }

      final List<AdministrativeUnit> provWards = [];
      final districts = p['districts'] as List<dynamic>? ?? [];
      for (final d in districts) {
        final dName = d['name'] as String;
        final wards = d['wards'] as List<dynamic>? ?? [];
        for (final w in wards) {
          final wId = w['id'] as String;
          final wCode = w['code'] as String? ?? wId;
          final wName = w['name'] as String;
          final wDistrict = w['district'] as String? ?? dName;
          final wAliases = (w['aliases'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();

          final wardUnit = AdministrativeUnit(
            code: wCode,
            name: wName,
            type: AdministrativeType.ward,
            parentCode: pCode,
            districtName: wDistrict,
            aliases: wAliases,
          );

          provWards.add(wardUnit);
          wardByCode[wCode] = wardUnit;
          wardByCode[wId] = wardUnit;
          for (final alias in wAliases) {
            wardByCode[alias] = wardUnit;
          }
        }
      }

      wardsByProv[pCode] = provWards;
      wardsByProv[pId] = provWards;
      for (final alias in pAliases) {
        wardsByProv[alias] = provWards;
      }
    }

    _cachedProvinces = provinces;
    _cachedWardsByProvince = wardsByProv;
    _cachedProvinceByCode = provinceByCode;
    _cachedWardByCode = wardByCode;
  }

  @override
  Future<List<AdministrativeUnit>> getProvinces({String? query}) async {
    await _ensureLoaded();
    final list = _cachedProvinces ?? [];
    if (query == null || query.trim().isEmpty) {
      return List.unmodifiable(list);
    }
    return list.where((p) => p.matchesQuery(query)).toList();
  }

  @override
  Future<List<AdministrativeUnit>> getWards(String provinceCode, {String? query}) async {
    await _ensureLoaded();
    final wards = _cachedWardsByProvince?[provinceCode] ?? [];
    if (query == null || query.trim().isEmpty) {
      return wards;
    }
    return wards.where((w) => w.matchesQuery(query)).toList();
  }

  @override
  AdministrativeUnit? getProvinceByCode(String code) {
    _ensureSyncLoaded();
    return _cachedProvinceByCode?[code];
  }

  @override
  AdministrativeUnit? getWardByCode(String code) {
    _ensureSyncLoaded();
    return _cachedWardByCode?[code];
  }

  @override
  String formatLocation(String? provinceCode, String? wardCode) {
    _ensureSyncLoaded();
    if (provinceCode == null || provinceCode.isEmpty) {
      return 'Toàn quốc';
    }
    final province = getProvinceByCode(provinceCode);
    final provinceName = province?.name ?? provinceCode;

    if (wardCode == null || wardCode.isEmpty) {
      return provinceName;
    }
    final ward = getWardByCode(wardCode);
    final wardName = ward?.name ?? wardCode;
    if (ward?.districtName != null) {
      return '$wardName, ${ward!.districtName}, $provinceName';
    }
    return '$wardName, $provinceName';
  }
}
