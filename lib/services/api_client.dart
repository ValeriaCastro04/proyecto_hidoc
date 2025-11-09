import 'package:dio/dio.dart';
import 'token_storage.dart';

/// Cliente HTTP único para toda la app.
/// Lee el access token (si existe) y lo agrega al header Authorization.
class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      // Cambia si tu API no corre en el 3000
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:3000',
      ),
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
}