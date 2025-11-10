import 'package:dio/dio.dart';
import 'package:proyecto_hidoc/services/api_client.dart';
import 'package:proyecto_hidoc/features/user/models/doctor_category.dart';
import 'package:proyecto_hidoc/features/user/models/doctor_model.dart';

class DoctorService {
  final Dio _dio = ApiClient.dio;

  // Categorías: GET /doctors/categories
  Future<List<DoctorCategoryDto>> fetchCategories() async {
    final resp = await _dio.get('/doctors/categories');
    final raw = resp.data;
    final list = (raw is List) ? raw : <dynamic>[];
    return list
        .whereType<Map>()
        .map((m) => DoctorCategoryDto.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  // Doctores por categoría: GET /doctors?category=GENERAL&page=1&limit=10
  Future<List<DoctorLite>> fetchDoctorsByCategoryCode(
    String categoryCode, {
    int page = 1,
    int limit = 10,
  }) async {
    final resp = await _dio.get('/doctors', queryParameters: {
      'category': categoryCode.toUpperCase(), // Aseguramos que sea mayúsculas
      'page': page,
      'limit': limit,
    });

    final body = (resp.data is Map) ? Map<String, dynamic>.from(resp.data) : <String, dynamic>{};
    final data = body['data'] ?? [];
    final list = (data is List) ? data : <dynamic>[];

    return list
        .whereType<Map>()
        .map((m) => DoctorLite.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  // Disponibilidad: GET /doctors/:id/availability
  Future<List<AvailabilitySlot>> fetchAvailability(String doctorId) async {
    final resp = await _dio.get('/doctors/$doctorId/availability');

    final raw = resp.data;
    // Soporta dos formatos: lista plana de slots o agrupado por días
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((m) => AvailabilitySlot.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    } else if (raw is Map && raw['data'] is List) {
      // por si algún día regresas { data: [...] }
      final list = raw['data'] as List;
      return list
          .whereType<Map>()
          .map((m) => AvailabilitySlot.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    } else if (raw is List<Map> && raw.isNotEmpty && raw.first['slots'] != null) {
      // formato agrupado [{ date, slots: [...] }]
      final List<AvailabilitySlot> acc = [];
      for (final day in raw) {
        final slots = day['slots'] as List? ?? const [];
        acc.addAll(slots
            .whereType<Map>()
            .map((m) => AvailabilitySlot.fromMap(Map<String, dynamic>.from(m))));
      }
      return acc;
    }
    return [];
  }
}