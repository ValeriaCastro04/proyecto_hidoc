// services/api_service.dart
import 'package:dio/dio.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:proyecto_hidoc/features/doctor/model/cita_doctor.dart';
import 'package:proyecto_hidoc/features/doctor/model/create_cita_dto.dart';
import 'package:proyecto_hidoc/features/doctor/model/patient.dart';

class ApiService {
  final Dio _dio;

  // Recibe la instancia de Dio (ya configurada con interceptores)
  ApiService(this._dio);

  /// GET /patients
  Future<List<Patient>> getPatients() async {
    try {
      final response = await _dio.get('/patients');
      List<Patient> patients = (response.data as List)
          .map((json) => Patient.fromJson(json))
          .toList();
      return patients;
    } on DioException catch (e) {
      // El interceptor ya manejó el refresh, esto es un error final
      throw Exception('Error al cargar pacientes: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// GET /cita-doctor/doctor/by-day
  Future<List<CitaDoctor>> getCitasByDay(DateTime date) async {
    final String dateString = DateFormat('yyyy-MM-dd').format(date);
    
    try {
      final response = await _dio.get(
        '/cita-doctor/doctor/by-day',
        queryParameters: {'date': dateString},
      );
      List<CitaDoctor> citas = (response.data as List)
          .map((json) => CitaDoctor.fromJson(json))
          .toList();
      return citas;
    } on DioException catch (e) {
      throw Exception('Error al cargar citas: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// POST /cita-doctor/doctor
  Future<CitaDoctor> createCita(CreateCitaDoctorDto dto) async {
    try {
      final response = await _dio.post(
        '/cita-doctor/doctor',
        data: dto.toJson(), // dio convierte el Map a JSON
      );
      return CitaDoctor.fromJson(response.data);
    } on DioException catch (e) {
      // NestJS envía errores 400 (Bad Request) con detalles
      if (e.response?.statusCode == 400) {
        throw Exception('Error: ${e.response?.data['message']}');
      }
      throw Exception('Error al crear la cita: ${e.response?.data['message'] ?? e.message}');
    }
  }

  /// GET /users/me
  Future<Map<String, dynamic>> getMyDoctorProfile() async {
  try {
    final response = await _dio.get('/users/me'); 
    return response.data as Map<String, dynamic>;
  } on DioException catch (e) {
    throw Exception('Error al cargar el perfil del doctor: ${e.response?.data['message'] ?? e.message}');
  }
}
}