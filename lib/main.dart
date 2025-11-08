import 'dart:io' show Platform; 
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

import 'package:proyecto_hidoc/config/router/app_router.dart';
import 'package:proyecto_hidoc/common/theme/app_theme.dart';
import 'package:proyecto_hidoc/common/theme/theme_provider.dart';

/// ===============================
/// Providers globales
/// ===============================

/// URL base del API. 
/// - En Web usa http://localhost:3000 (o la IP/host donde corra Nest)
/// - En Android Emu usa 10.0.2.2
/// - En otros (iOS sim/desktop) usa localhost
final baseUrlProvider = Provider<String>((ref) {
  const envUrl = String.fromEnvironment('API_URL'); // opcional: --dart-define
  if (envUrl.isNotEmpty) return envUrl;

  if (kIsWeb) {
    // Flutter web corre en un puerto aleatorio: habilita CORS en Nest (ver abajo)
    return 'http://localhost:3000';
  }

  try {
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
  } catch (_) {
    // no-op
  }
  return 'http://localhost:3000';
});

/// Almacenamiento seguro de tokens (usa localStorage en Web)
class TokenStorage {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';

  // En Web, FlutterSecureStorage usa localStorage/indexedDB.
  // Declaramos webOptions para tener una "db" nombrada.
  final _s = const FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'hidoc_secure_db',
      publicKey: 'hidoc_web_key',
    ),
  );

  Future<void> save({required String access, required String refresh}) async {
    await _s.write(key: _kAccess, value: access);
    await _s.write(key: _kRefresh, value: refresh);
  }

  Future<String?> get access async => _s.read(key: _kAccess);
  Future<String?> get refresh async => _s.read(key: _kRefresh);

  Future<void> clear() async {
    await _s.delete(key: _kAccess);
    await _s.delete(key: _kRefresh);
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

/// Dio con:
/// - baseUrl
/// - interceptor: agrega Authorization Bearer si hay token
/// - auto-refresh con /auth/refresh ante 401 (una sola vez)
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
        final token = await storage.access;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (e, handler) async {
        final is401 = e.response?.statusCode == 401;
        final retried = e.requestOptions.extra['__retried__'] == true;
        if (!is401 || retried) return handler.next(e);

        final ok = await _tryRefresh(dio, storage);
        if (!ok) return handler.next(e);

        // reintenta
        final req = e.requestOptions;
        req.extra['__retried__'] = true;
        final newAccess = await storage.access;
        if (newAccess != null) {
          req.headers['Authorization'] = 'Bearer $newAccess';
        }
        try {
          final clone = await dio.fetch(req);
          return handler.resolve(clone);
        } catch (err) {
          return handler.next(err as DioException);
        }
      },
    ),
  );

  return dio;
});

Future<bool> _tryRefresh(Dio dio, TokenStorage storage) async {
  final refresh = await storage.refresh;
  if (refresh == null) return false;
  try {
    if (Jwt.isExpired(refresh)) return false;

    final res = await dio.post(
      '/auth/refresh',
      data: {'refreshToken': refresh},
      options: Options(headers: {'Authorization': null}), // sin Bearer
    );
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

/// ===============================
/// App
/// ===============================

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fuerza la inicialización de Dio al arranque
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