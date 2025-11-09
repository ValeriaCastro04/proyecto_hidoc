import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'token_storage.dart';

class ApiClient {
  final Dio dio;
  final TokenStorage storage;

  ApiClient(String baseUrl, this.storage)
      : dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 10)));

  void attachInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.access;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) async {
        // Si 401, intenta refresh una única vez
        final reqOptions = e.requestOptions;
        if (e.response?.statusCode == 401 && !(reqOptions.extra['retried'] == true)) {
          final ok = await _tryRefresh();
          if (ok) {
            reqOptions.extra['retried'] = true;
            final token = await storage.access;
            reqOptions.headers['Authorization'] = 'Bearer $token';
            final clone = await dio.fetch(reqOptions);
            return handler.resolve(clone);
          }
        }
        return handler.next(e);
      },
    ));
  }

  Future<bool> _tryRefresh() async {
    final refresh = await storage.refresh;
    if (refresh == null) return false;
    try {
      // opcional: valida expiración del refresh
      if (Jwt.isExpired(refresh)) return false;

      final res = await dio.post('/auth/refresh', data: {'refreshToken': refresh},
          options: Options(headers: {'Authorization': null})); // sin bearer aquí
      final access = res.data['access_token'] as String?;
      final newRefresh = res.data['refresh_token'] as String?;
      if (access != null && newRefresh != null) {
        await storage.save(access: access, refresh: newRefresh);
        return true;
      }
    } catch (_) {}
    await storage.clear();
    return false;
  }
}
