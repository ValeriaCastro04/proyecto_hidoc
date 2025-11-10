import 'dart:async';
import 'package:dio/dio.dart';
import 'token_storage.dart';
import 'package:proyecto_hidoc/config/router/router_notifier.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:3000',
      ),
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static bool _isRefreshing = false;
  static final List<_Queued> _queue = [];

  static void _addAuth(RequestOptions o, String? token) {
    if (token != null && token.isNotEmpty) {
      o.headers['Authorization'] = 'Bearer $token';
    } else {
      o.headers.remove('Authorization');
    }
  }

  static Future<void> _setupOnce() async {
    // evita duplicar interceptores en hot-reload
    if (dio.interceptors.isNotEmpty) return;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // no metas Authorization en /auth/refresh
          if (options.extra['skipAuth'] == true) {
            return handler.next(options);
          }
          final token = await TokenStorage.getAccessToken();
          _addAuth(options, token);
          handler.next(options);
        },
        onError: (e, handler) async {
          final is401 = e.response?.statusCode == 401;
          final retried = e.requestOptions.extra['__retry__'] == true;
          if (!is401 || retried) return handler.next(e);

          // Cola esta request para resolverla tras el refresh
          final completer = Completer<Response>();
          _queue.add(_Queued(e.requestOptions, completer));

          if (_isRefreshing) {
            // espera a que termine el refresh en curso
            final r = await completer.future;
            return handler.resolve(r);
          }

          _isRefreshing = true;
          try {
            final newAccess = await _refreshToken();
            // reintentar todo lo encolado
            for (final q in _queue) {
              final ro = q.req;
              ro.extra['__retry__'] = true;
              _addAuth(ro, newAccess);
              try {
                final resp = await dio.fetch(ro);
                q.completer.complete(resp);
              } catch (err) {
                q.completer.completeError(err);
              }
            }
            _queue.clear();
          } catch (err) {
            // falló el refresh → limpiar tokens y propagar 401
            await TokenStorage.clear();
            // informar al notifier global que no hay sesión
            routerNotifier.isLoggedIn = false;
            routerNotifier.isDoctor = false;
            for (final q in _queue) {
              q.completer.completeError(e);
            }
            _queue.clear();
            return handler.next(e);
          } finally {
            _isRefreshing = false;
          }

          final r = await completer.future;
          return handler.resolve(r);
        },
      ),
    );
  }

  static Future<String> _refreshToken() async {
    final refresh = await TokenStorage.getRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      throw Exception('No refresh token');
    }

    final resp = await dio.post(
      '/auth/refresh',
      data: {'refreshToken': refresh},
      options: Options(extra: {'skipAuth': true}), // sin Authorization
    );

    final data = resp.data is Map ? resp.data as Map : {};
    final access = (data['access_token'] ?? data['accessToken'])?.toString();
    final newRefresh = (data['refresh_token'] ?? data['refreshToken'])?.toString();

    if (access == null || access.isEmpty) {
      throw Exception('Refresh sin access_token');
    }

    await TokenStorage.saveAccessToken(access);
    if (newRefresh != null && newRefresh.isNotEmpty) {
      await TokenStorage.saveRefreshToken(newRefresh);
    }
    return access;
  }

  /// Llama a esto UNA vez (por ej. en main.dart antes de usar ApiClient.dio)
  static Future<void> init() => _setupOnce();
}

class _Queued {
  final RequestOptions req;
  final Completer<Response> completer;
  _Queued(this.req, this.completer);
}