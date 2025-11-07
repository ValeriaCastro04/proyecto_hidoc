// lib/main.dart
import 'dart:io';
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

/// URL base del API. Ajusta según entorno.
/// - Android emulator: 10.0.2.2
/// - iOS simulator: localhost
/// - Dispositivo físico: IP de tu PC
final baseUrlProvider = Provider<String>((ref) {
  const envUrl = String.fromEnvironment('API_URL'); // opcional: --dart-define
  if (envUrl.isNotEmpty) return envUrl;

  if (Platform.isAndroid) return 'http://10.0.2.2:3000';
  return 'http://localhost:3000';
});

/// Almacenamiento seguro de tokens
class TokenStorage {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  final _s = const FlutterSecureStorage();

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

/// Dio configurado con:
/// - baseUrl
/// - interceptor que agrega Authorization
/// - reintento con /auth/refresh si recibe 401
final dioProvider = Provider<Dio>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  final storage = ref.watch(tokenStorageProvider);

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    // Asegura JSON por defecto
    headers: {'Content-Type': 'application/json'},
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await storage.access;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (e, handler) async {
      // Si no es 401 o ya reintentamos, sigue el error
      final is401 = e.response?.statusCode == 401;
      final retried = e.requestOptions.extra['__retried__'] == true;
      if (!is401 || retried) return handler.next(e);

      // Intento de refresh
      final ok = await _tryRefresh(dio, storage);
      if (!ok) return handler.next(e);

      // Reintentar la petición original con nuevo access token
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
  ));

  return dio;
});

/// Lógica de refresh simple
Future<bool> _tryRefresh(Dio dio, TokenStorage storage) async {
  final refresh = await storage.refresh;
  if (refresh == null) return false;
  try {
    // opcional: si el refresh está vencido, corta
    if (Jwt.isExpired(refresh)) return false;

    final res = await dio.post(
      '/auth/refresh',
      data: {'refreshToken': refresh},
      // Importante: NO mandar Authorization aquí
      options: Options(headers: {'Authorization': null}),
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
    // Fuerza la inicialización de Dio una vez al arranque
    ref.watch(dioProvider);

    final mode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'HiDoc!',
      routerConfig: appRouter, // tu GoRouter existente
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: mode,
    );
  }
}