// lib/features/auth/auth_api.dart
import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio;
  AuthApi(this._dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    return Map<String, dynamic>.from(res.data);
  }

  Future<Map<String, dynamic>> registerDoctor({
    required String fullName,
    required String email,
    required String password,
    required String professionalId,
  }) async {
    final res = await _dio.post('/auth/register', data: {
      'fullName': fullName,
      'email': email,
      'password': password,
      'role': 'DOCTOR',
      'professionalId': professionalId,
      'acceptTerms': true,
    });
    return Map<String, dynamic>.from(res.data);
  }

  Future<Map<String, dynamic>> me() async {
    final res = await _dio.get('/auth/me');
    return Map<String, dynamic>.from(res.data);
  }

  Future<void> logout() async {
    try { await _dio.post('/auth/logout'); } catch (_) {}
  }
}