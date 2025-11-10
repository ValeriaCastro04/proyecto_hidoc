import 'package:dio/dio.dart';
import 'package:proyecto_hidoc/services/api_client.dart';

class AppointmentService {
  static Future<String> createAfterPayment({
    required String doctorId,
    required String paymentId,
    String mode = 'CHAT', // CHAT | LLAMADA | VIDEO
  }) async {
    final resp = await ApiClient.dio.post(
      '/v1/appointments',
      data: {
        'doctorId': doctorId,
        'kind': mode,
        'status': 'CONFIRMED',
        'paymentId': paymentId,
      },
      options: Options(validateStatus: (s) => (s ?? 500) < 500),
    );

    if ((resp.statusCode ?? 500) >= 400) {
      throw Exception('Error al crear cita (${resp.statusCode})');
    }

    final d = resp.data is Map ? resp.data as Map : {};
    return (d['id'] ?? d['_id'] ?? '').toString();
  }
}