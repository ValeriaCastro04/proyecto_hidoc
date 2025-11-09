// lib/features/auth/screen/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:proyecto_hidoc/main.dart' show dioProvider, tokenStorageProvider;
import 'package:proyecto_hidoc/services/token_storage.dart';

import 'package:proyecto_hidoc/common/layout/scroll_fill.dart';
import 'package:proyecto_hidoc/common/shared_widgets/app_logo.dart';
import 'package:proyecto_hidoc/common/shared_widgets/auth_card.dart';
import 'package:proyecto_hidoc/common/shared_widgets/icon_text_field.dart';
import 'package:proyecto_hidoc/common/shared_widgets/segmented_role_toggle.dart' as seg;

import 'package:proyecto_hidoc/common/global_widgets/solid_button.dart';
import 'package:proyecto_hidoc/features/auth/screen/register_screen.dart';
import 'package:proyecto_hidoc/features/doctor/screen/homedoctor_screen.dart';
import 'package:proyecto_hidoc/features/user/screen/homeuser_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String name = 'Login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  String? _errorText;

  seg.UserRole _role = seg.UserRole.patient;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ingresa tu correo';
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!re.hasMatch(v.trim())) return 'Correo inválido';
    return null;
  }

  String? _passValidator(String? v) {
    if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
    if (v.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  void _showSnack(String msg, {bool error = false}) {
    final cs = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: error ? cs.error : cs.primary),
    );
  }

  Future<void> _cacheUserMeta({
    required String name,
    required String role,
    required String email,
  }) async {
    try {
      final sp = await SharedPreferences.getInstance();
      if (name.isNotEmpty) await sp.setString('user_name', name);
      if (role.isNotEmpty) await sp.setString('user_role', role);
      if (email.isNotEmpty) await sp.setString('user_email', email);
    } catch (_) {
      // no bloquear el flujo si falla el cache
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorText = null;
    });

    final dio = ref.read(dioProvider);
    final storage = ref.read(tokenStorageProvider);

    try {
      final res = await dio.post('/auth/login', data: {
        'email': _email.text.trim(),
        'password': _password.text,
      });

      final data = res.data as Map<String, dynamic>;

      // Acepta ambas convenciones de nombres
      final access = (data['access_token'] ?? data['accessToken'])?.toString();
      final refresh = (data['refresh_token'] ?? data['refreshToken'])?.toString();
      final user = (data['user'] ?? const {}) as Map<String, dynamic>;

      if (access == null || refresh == null) {
        throw Exception('Respuesta inválida del servidor (faltan tokens)');
      }

      // Guarda tokens en SecureStorage (vía provider moderno)
      await storage.save(access: access, refresh: refresh);

      // Y también en SharedPreferences para compatibilidad con ApiClient.dio
      try {
        await TokenStorage.saveAccessToken(access);
        await TokenStorage.saveRefreshToken(refresh);
      } catch (_) {}

      // === NUEVO: Cachear nombre/rol/email para saludo inmediato ===
      final roleStr = (user['role'] ?? '').toString();
      final emailStr = (user['email'] ?? _email.text.trim()).toString();
      final nameStr = (user['name'] ?? user['fullName'] ?? user['fullname'] ?? '').toString();
      await _cacheUserMeta(name: nameStr, role: roleStr, email: emailStr);

      // Navega según rol
      if (!mounted) return;
      final roleUpper = roleStr.toUpperCase();
      if (roleUpper == 'DOCTOR') {
        context.goNamed(HomeDoctorScreen.name);
      } else {
        context.goNamed(HomeUserScreen.name);
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      String msg = 'Error de red';
      if (status == 401) {
        msg = 'Credenciales inválidas';
      } else if (e.response?.data is Map &&
          (e.response!.data as Map).containsKey('message')) {
        final m = e.response!.data['message'];
        msg = m is List ? m.join(', ') : m.toString();
      }
      setState(() => _errorText = msg);
      _showSnack(msg, error: true);
    } catch (_) {
      const msg = 'Ocurrió un error al iniciar sesión';
      setState(() => _errorText = msg);
      _showSnack(msg, error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ScrollFill(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const AppLogo(height: 56),
                  const SizedBox(height: 12),
                  AuthCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '¡Bienvenido a HiDoc!',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tu salud digital en El Salvador',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(.8),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Text('Tipo de usuario:',
                              style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          seg.SegmentedRoleToggle(
                            value: _role,
                            onChanged: (seg.UserRole r) => setState(() => _role = r),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.black87,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {}, // ya estás en login
                                  child: const Text('Iniciar sesión',
                                      style: TextStyle(fontWeight: FontWeight.w700)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: cs.outline.withOpacity(.35), width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: _loading ? null : () => context.pushNamed(RegisterScreen.name),
                                  child: const Text('Registrarse',
                                      style: TextStyle(fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          IgnorePointer(
                            ignoring: _loading,
                            child: Column(
                              children: [
                                IconTextField(
                                  controller: _email,
                                  label: 'Correo electrónico',
                                  hint: 'tu@email.com',
                                  icon: Icons.mail_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _emailValidator,
                                ),
                                const SizedBox(height: 12),
                                IconTextField(
                                  controller: _password,
                                  label: 'Contraseña',
                                  hint: '•••••••',
                                  icon: Icons.lock_rounded,
                                  obscure: _obscure,
                                  onToggleObscure: () =>
                                      setState(() => _obscure = !_obscure),
                                  validator: _passValidator,
                                ),
                              ],
                            ),
                          ),

                          if (_errorText != null) ...[
                            const SizedBox(height: 8),
                            Text(_errorText!, style: TextStyle(color: cs.error)),
                          ],

                          const SizedBox(height: 18),
                          SolidButton(
                            text: _loading ? 'Ingresando...' : 'Iniciar sesión',
                            expand: true,
                            onPressed: _loading ? null : _submit,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cuidando tu salud con tecnología',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}