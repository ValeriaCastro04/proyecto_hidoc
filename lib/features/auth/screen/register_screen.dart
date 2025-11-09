import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:proyecto_hidoc/common/layout/scroll_fill.dart';
import 'package:proyecto_hidoc/common/shared_widgets/app_logo.dart';
import 'package:proyecto_hidoc/common/shared_widgets/auth_card.dart';
import 'package:proyecto_hidoc/common/shared_widgets/icon_text_field.dart';
import 'package:proyecto_hidoc/common/shared_widgets/segmented_role_toggle.dart'
    as role; // alias para el enum UserRole
import 'package:proyecto_hidoc/common/global_widgets/solid_button.dart';

import 'package:proyecto_hidoc/features/auth/screen/login_screen.dart';
import 'package:proyecto_hidoc/features/user/screen/homeuser_screen.dart';
import 'package:proyecto_hidoc/features/doctor/screen/homedoctor_screen.dart';

import 'package:proyecto_hidoc/services/api_client.dart';
import 'package:proyecto_hidoc/services/token_storage.dart';

class RegisterScreen extends StatefulWidget {
  static const String name = 'Register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  final _proId = TextEditingController(); // solo médico

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _accept = false;
  bool _affirmMed = false;

  bool _loading = false;
  String? _errorText;

  role.UserRole _role = role.UserRole.patient;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _proId.dispose();
    super.dispose();
  }

  String? _nameValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ingresa tu nombre completo';
    if (v.trim().length < 3) return 'Escribe al menos 3 caracteres';
    return null;
  }

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ingresa tu correo';
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!re.hasMatch(v.trim())) return 'Correo inválido';
    return null;
  }

  String? _passValidator(String? v) {
    if (v == null || v.isEmpty) return 'Ingresa una contraseña';
    if (v.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  String? _confirmValidator(String? v) {
    if (v == null || v.isEmpty) return 'Confirma la contraseña';
    if (v != _password.text) return 'Las contraseñas no coinciden';
    return null;
  }

  Future<void> _cacheUserName(String name, {String? roleStr, String? email}) async {
    try {
      final sp = await SharedPreferences.getInstance();
      if (name.isNotEmpty) await sp.setString('user_name', name);
      if (roleStr != null && roleStr.isNotEmpty) await sp.setString('user_role', roleStr);
      if (email != null && email.isNotEmpty) await sp.setString('user_email', email);
    } catch (_) {
      // no bloquear el flujo si no se puede cachear
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_accept) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar los términos y condiciones')),
      );
      return;
    }
    if (_role == role.UserRole.doctor && !_affirmMed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes afirmar la aprobación de tu identificación profesional')),
      );
      return;
    }

    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      final dio = ApiClient.dio;
      final apiRole = _role == role.UserRole.doctor ? 'DOCTOR' : 'PATIENT';

      final payload = <String, dynamic>{
        'fullName': _name.text.trim(),
        'email': _email.text.trim(),
        'password': _password.text,
        'role': apiRole,
        'acceptTerms': true, // tu back lo valida
      };

      if (_role == role.UserRole.doctor) {
        final pro = _proId.text.trim();
        if (pro.isNotEmpty) payload['professionalId'] = pro;
        // opcional si decides usarlo en back:
        payload['boardApproved'] = _affirmMed;
      }

      final res = await dio.post('/auth/register', data: payload);
      final body = res.data as Map;

      final access = (body['access_token'] ?? body['accessToken'])?.toString();
      final refresh = (body['refresh_token'] ?? body['refreshToken'])?.toString();
      final user = (body['user'] ?? const {}) as Map;

      if (access == null || refresh == null) {
        throw Exception('Respuesta inválida del servidor (faltan tokens)');
      }

      // 1) Guarda tokens en SharedPreferences (ApiClient.dio usa esto)
      await TokenStorage.saveAccessToken(access);
      await TokenStorage.saveRefreshToken(refresh);

      // 2) Guarda tokens también en SecureStorage (paridad con login moderno)
      try {
        const secure = FlutterSecureStorage(
          webOptions: WebOptions(dbName: 'hidoc_secure_db', publicKey: 'hidoc_web_key'),
        );
        await secure.write(key: 'access_token', value: access);
        await secure.write(key: 'refresh_token', value: refresh);
      } catch (_) {}

      // 3) Cachea nombre/rol/email para el saludo inmediato
      final name = (user['name'] ?? _name.text.trim()).toString();
      final roleResp = (user['role'] ?? apiRole).toString();
      final emailResp = (user['email'] ?? _email.text.trim()).toString();
      await _cacheUserName(name, roleStr: roleResp, email: emailResp);

      // 4) Navega por rol
      if (!mounted) return;
      final roleUpper = roleResp.toUpperCase();
      if (roleUpper == 'DOCTOR') {
        context.goNamed(HomeDoctorScreen.name);
      } else {
        context.goNamed(HomeUserScreen.name);
      }
    } on DioException catch (e) {
      String msg = 'Error de red';
      if (e.type == DioExceptionType.connectionError) {
        msg = 'No se pudo conectar con la API (¿corre en http://localhost:3000?).';
      } else if (e.response != null) {
        final body = e.response?.data;
        if (body is Map && body['message'] != null) {
          final m = body['message'];
          if (m is String) {
            msg = m;
          } else if (m is List && m.isNotEmpty) {
            msg = m.join(', ');
          } else {
            msg = m.toString();
          }
        } else {
          msg = 'Error ${e.response?.statusCode ?? ''}'.trim();
        }
      }
      setState(() => _errorText = msg);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (_) {
      const msg = 'Ocurrió un error inesperado';
      setState(() => _errorText = msg);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDoctor = _role == role.UserRole.doctor;

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
                            'Crea tu cuenta',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Regístrate para acceder a HiDoc',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(.8),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Text('Tipo de usuario:',
                              style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          role.SegmentedRoleToggle(
                            value: _role,
                            onChanged: (r) => setState(() => _role = r),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: cs.outline.withOpacity(.35), width: 1.5),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: _loading ? null : () => context.goNamed(LoginScreen.name),
                                  child: const Text('Iniciar sesión',
                                      style: TextStyle(fontWeight: FontWeight.w700)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.black87,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {}, // ya estás en registro
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
                                  controller: _name,
                                  label: 'Nombre completo',
                                  hint: 'Nombre y apellido',
                                  icon: Icons.badge_rounded,
                                  validator: _nameValidator,
                                ),
                                const SizedBox(height: 12),
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
                                  obscure: _obscure1,
                                  onToggleObscure: () => setState(() => _obscure1 = !_obscure1),
                                  validator: _passValidator,
                                ),
                                const SizedBox(height: 12),
                                IconTextField(
                                  controller: _confirm,
                                  label: 'Confirmar contraseña',
                                  hint: 'Repite tu contraseña',
                                  icon: Icons.lock_person_rounded,
                                  obscure: _obscure2,
                                  onToggleObscure: () => setState(() => _obscure2 = !_obscure2),
                                  validator: _confirmValidator,
                                ),
                                if (isDoctor) ...[
                                  const SizedBox(height: 12),
                                  IconTextField(
                                    controller: _proId,
                                    label: 'Número de identificación profesional',
                                    hint: 'JVPM-123456',
                                    icon: Icons.medical_information_rounded,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _affirmMed,
                                        onChanged: (v) => setState(() => _affirmMed = v ?? false),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Afirmo que mi identificación profesional como médico está aprobada por la Junta de Vigilancia de la Profesión Médica',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _accept,
                                      onChanged: (v) => setState(() => _accept = v ?? false),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Acepto los términos y condiciones y la política de privacidad.',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          if (_errorText != null) ...[
                            const SizedBox(height: 8),
                            Text(_errorText!, style: TextStyle(color: cs.error)),
                          ],

                          const SizedBox(height: 12),
                          SolidButton(
                            text: _loading ? 'Creando cuenta...' : 'Crear cuenta',
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