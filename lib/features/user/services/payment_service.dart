import 'package:dio/dio.dart';
import 'package:proyecto_hidoc/services/api_client.dart';

class CheckoutResponse {
  final String appointmentId;
  final String paymentId;
  final String doctorName;
  final String maskedMethod;

  CheckoutResponse({
    required this.appointmentId,
    required this.paymentId,
    required this.doctorName,
    required this.maskedMethod,
  });

  factory CheckoutResponse.fromMap(Map<String, dynamic> m) => CheckoutResponse(
    appointmentId: (m['appointmentId'] ?? '').toString(),
    paymentId: (m['paymentId'] ?? '').toString(),
    doctorName: (m['doctorName'] ?? '').toString(),
    maskedMethod: (m['maskedMethod'] ?? '').toString(),
  );
}

class PaymentService {
  final dio = ApiClient.dio;

  Future<CheckoutResponse> checkoutConsultation({
    required String doctorId,
    required double amount,
    required String concept,
    required String method, // 'card' | 'tigo'
    String? cardPan,
    String? cardExp, // MM/AA
    String? cardCvv,
    String? cardHolder,
  }) async {
    final body = {
      'doctorId': doctorId,
      'amount': amount,
      'concept': concept,
      'method': method,
      if (method == 'card')
        'card': {
          'pan': cardPan,
          'exp': cardExp,
          'cvv': cardCvv,
          'holder': cardHolder,
        },
    };

    final res = await dio.post('/v1/checkout/consultation', data: body);
    return CheckoutResponse.fromMap(res.data as Map<String, dynamic>);
  }
}