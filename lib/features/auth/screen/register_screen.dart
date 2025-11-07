import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:proyecto_hidoc/common/layout/scroll_fill.dart';
import 'package:proyecto_hidoc/common/shared_widgets/app_logo.dart';
import 'package:proyecto_hidoc/common/shared_widgets/auth_card.dart';
import 'package:proyecto_hidoc/common/shared_widgets/icon_text_field.dart';
import 'package:proyecto_hidoc/common/shared_widgets/segmented_role_toggle.dart';
import 'package:proyecto_hidoc/common/global_widgets/solid_button.dart';

import 'package:proyecto_hidoc/features/auth/screen/login_screen.dart';
import 'package:proyecto_hidoc/features/user/screen/homeuser_screen.dart';
import 'package:proyecto_hidoc/features/doctor/screen/homedoctor_screen.dart';

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

  // NUEVO: controlador para identificación profesional (solo médico)
  final _proId = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _accept = false;

  // NUEVO: checkbox de afirmación (solo médico)
  bool _affirmMed = false;

  UserRole _role = UserRole.patient;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _proId.dispose(); // NUEVO
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_accept) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar los términos y condiciones')),
      );
      return;
    }

    // Sin autenticación: redirige por rol
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
                          SegmentedRoleToggle(
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
                                  onPressed: () => context.goNamed(LoginScreen.name),
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

                          // NUEVO: Campo visible solo si rol = médico
                          if (_role == UserRole.doctor) ...[
                            const SizedBox(height: 12),
                            IconTextField(
                              controller: _proId,
                              label: 'Número de identificación profesional',
                              hint: 'Ej: 123456',
                              icon: Icons.medical_information_rounded,
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

                          // NUEVO: Checkbox adicional bajo T&C (solo médico)
                          if (_role == UserRole.doctor) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Checkbox(
                                  value: _affirmMed,
                                  onChanged: (v) => setState(() => _affirmMed = v ?? false),
                                ),
                                Expanded(
                                  child: Text(
                                    'Afirmo que mi identificación profesional como médico está aprobado por la Junta de Vigilancia de la Profesión Médica.',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 12),
                          SolidButton(
                            text: 'Crear cuenta',
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