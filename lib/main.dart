import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:proyecto_hidoc/services/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'features/doctor/services/api_service.dart';

import 'package:proyecto_hidoc/config/router/app_router.dart';
import 'package:proyecto_hidoc/common/theme/app_theme.dart';
import 'package:proyecto_hidoc/common/theme/theme_provider.dart';
 
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  // ApiService y le "inyecta" el dio
  return ApiService(dio);
});
final doctorProfileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  // Obtenemos el servicio de API
  final apiService = ref.watch(apiServiceProvider); 
  return await apiService.getMyDoctorProfile();
});
final baseUrlProvider = Provider<String>((ref) {
  const envUrl = String.fromEnvironment('API_URL');
  if (envUrl.isNotEmpty) return envUrl;

  if (kIsWeb) return 'http://localhost:3000';

  try {
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
  } catch (_) {}
  return 'http://localhost:3000';
});

/// Almacenamiento seguro de tokens (usa WebOptions en Web)
class TokenStorage {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';

  final _s = const FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'hidoc_secure_db',
      publicKey: 'hidoc_web_key',
    ),
  );

  Future<void> save({required String access, String? refresh}) async {
    await _s.write(key: _kAccess, value: access);
    if (refresh != null) {
      await _s.write(key: _kRefresh, value: refresh);
    }
  }

  Future<String?> get access async => _s.read(key: _kAccess);
  Future<String?> get refresh async => _s.read(key: _kRefresh);

  Future<void> clear() async {
    await _s.delete(key: _kAccess);
    await _s.delete(key: _kRefresh);
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  final storage = ref.watch(tokenStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Respeta banderas para saltar auth (e.g., refresh)
        final skipAuth = options.extra['skipAuth'] == true;
        if (!skipAuth) {
          final token = await storage.access;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        handler.next(options);
      },
      onError: (e, handler) async {
        final is401 = e.response?.statusCode == 401;
        final retried = e.requestOptions.extra['__retried__'] == true;

        if (!is401 || retried) return handler.next(e);

        // Intenta refrescar
        final refreshed = await _tryRefresh(dio, storage);
        if (!refreshed) return handler.next(e);

        // Reintenta la request original con el nuevo access
        final orig = e.requestOptions;
        orig.extra['__retried__'] = true; // evita bucle
        final newAccess = await storage.access;
        if (newAccess != null && newAccess.isNotEmpty) {
          orig.headers['Authorization'] = 'Bearer $newAccess';
        }
        try {
          final clone = await dio.fetch(orig);
          return handler.resolve(clone);
        } catch (err) {
          return handler.next(err is DioException ? err : DioException(
            requestOptions: orig,
            error: err,
          ));
        }
      },
    ),
  );

  return dio;
});

Future<bool> _tryRefresh(Dio dio, TokenStorage storage) async {
  final refresh = await storage.refresh;
  if (refresh == null || refresh.isEmpty) return false;

  // Si el refresh parece JWT, valida expiración; si no, continúa.
  final looksJwt = refresh.split('.').length == 3;
  if (looksJwt) {
    try {
      if (Jwt.isExpired(refresh)) return false;
    } catch (_) {
      // si falla el decode, seguimos intentando
    }
  }

  try {
    final resp = await dio.post(
      '/auth/refresh',
      data: {'refreshToken': refresh},
      // Evita que el interceptor meta Authorization en /auth/refresh
      options: Options(extra: {'skipAuth': true}),
    );

    final data = resp.data is Map ? resp.data as Map : {};
    final access =
        (data['accessToken'] ?? data['access_token'])?.toString();
    final newRefresh =
        (data['refreshToken'] ?? data['refresh_token'])?.toString();

    if (access == null || access.isEmpty) {
      await storage.clear();
      return false;
    }

    await storage.save(access: access, refresh: newRefresh);
    return true;
  } catch (_) {
    await storage.clear();
    return false;
  }
}

/// ===============================
/// App
/// ===============================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa el ApiClient (adjunta interceptores que usan SharedPreferences)
  // Esto garantiza que `ApiClient.dio` tenga los interceptors listos si partes de la app
  // usan el cliente estático (ej: `ApiClient.dio` en widgets antiguos).
  await ApiClient.init();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Inicializa Dio (registra interceptor) al arranque
    ref.watch(dioProvider);

    final mode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'HiDoc!',
      routerConfig: appRouter,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: mode,
    );
  }
}
