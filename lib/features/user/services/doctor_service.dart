import 'package:dio/dio.dart';
import 'package:proyecto_hidoc/features/user/models/doctor_model.dart';
import 'package:proyecto_hidoc/features/user/models/doctor_category.dart';
import 'package:proyecto_hidoc/services/api_client.dart';

class DoctorService {
  Dio get _dio => ApiClient.dio;

  Future<List<DoctorCategoryDto>> fetchCategories() async {
    final r = await _dio.get('/v1/doctors/categories');
    final data = (r.data is List) ? (r.data as List) : (r.data['data'] ?? []);
    return data.map<DoctorCategoryDto>((e) => DoctorCategoryDto.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  /// Devuelve doctores por CODE de categoría (GENERAL/ESPECIALIZADA/PEDIATRIA),
  /// priorizando los más nuevos (para que se vean primero los creados por registro).
  Future<List<DoctorLite>> fetchDoctorsByCategoryCode(String categoryCode,
      {int page = 1, int limit = 20}) async {
    final r = await _dio.get('/v1/doctors', queryParameters: {
      'category': categoryCode,
      'sort': 'createdAt:desc',
      'page': page,
      'limit': limit,
    });
    final data = (r.data is List) ? (r.data as List) : (r.data['data'] ?? []);
    final docs = data.map<DoctorLite>((e) => DoctorLite.fromJson(Map<String, dynamic>.from(e))).toList();

    // Fallback extra por si el seeder tiene createdAt reciente:
    // si API expone isSeeded, ponemos primero isSeeded=false.
    docs.sort((a, b) {
      final aSeed = a.isSeeded == true ? 1 : 0;
      final bSeed = b.isSeeded == true ? 1 : 0;
      if (aSeed != bSeed) return aSeed.compareTo(bSeed); // 0 (first) vs 1
      // luego por createdAt desc
      final aC = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bC = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bC.compareTo(aC);
    });

    return docs;
  }

  Future<List<AvailabilitySlot>> fetchAvailability(String doctorId) async {
    final r = await _dio.get('/v1/doctors/$doctorId/availability');
    final data = (r.data is List) ? (r.data as List) : (r.data['data'] ?? []);
    return data.map<AvailabilitySlot>((e) => AvailabilitySlot.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}