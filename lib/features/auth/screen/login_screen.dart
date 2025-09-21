import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:proyecto_hidoc/common/layout/scroll_fill.dart';
import 'package:proyecto_hidoc/common/shared_widgets/app_logo.dart';
import 'package:proyecto_hidoc/common/shared_widgets/auth_card.dart';
import 'package:proyecto_hidoc/common/shared_widgets/icon_text_field.dart';
import 'package:proyecto_hidoc/common/shared_widgets/segmented_role_toggle.dart';
import 'package:proyecto_hidoc/common/global_widgets/solid_button.dart';

import 'package:proyecto_hidoc/features/auth/screen/register_screen.dart';
import 'package:proyecto_hidoc/features/doctor/screen/homedoctor_screen.dart';

import 'package:proyecto_hidoc/features/user/screen/homeuser_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String name = 'Login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _obscure = true;
  UserRole _role = UserRole.patient;

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Sin autenticación: redirige solo por rol
    if (!mounted) return;
    if (_role == UserRole.doctor) {
      context.goNamed(HomeDoctorScreen.name);
    } else {
      context.goNamed(HomeUserScreen.name);
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
                          SegmentedRoleToggle(
                            value: _role,
                            onChanged: (r) => setState(() => _role = r),
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
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () => context.pushNamed(RegisterScreen.name),
                                  child: const Text('Registrarse',
                                      style: TextStyle(fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

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
                            onToggleObscure: () => setState(() => _obscure = !_obscure),
                            validator: _passValidator,
                          ),

                          const SizedBox(height: 18),
                          SolidButton(
                            text: 'Iniciar sesión',
                            expand: true,
                            onPressed: _submit,
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