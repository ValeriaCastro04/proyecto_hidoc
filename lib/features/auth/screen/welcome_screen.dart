import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:proyecto_hidoc/common/layout/scroll_fill.dart';
import 'package:proyecto_hidoc/common/shared_widgets/app_logo.dart';
import 'package:proyecto_hidoc/common/shared_widgets/section_heading.dart';
import 'package:proyecto_hidoc/common/shared_widgets/benefit_tile.dart';
import 'package:proyecto_hidoc/common/global_widgets/solid_button.dart';

import 'package:proyecto_hidoc/features/auth/screen/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String name = 'Welcome';
  const WelcomeScreen({super.key});

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  const AppLogo(),
                  const SizedBox(height: 12),

                  Text(
                    '¡Bienvenido a HiDoc!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tu salud digital en El Salvador.\n'
                    'Consultas médicas profesionales desde la comodidad de tu hogar.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(.85),
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 20),
                  SolidButton(
                    text: 'Comenzar',
                    expand: true,
                    onPressed: () => context.goNamed(LoginScreen.name),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () => context.goNamed(LoginScreen.name),
                      child: Text(
                        '¿Ya tienes cuenta? Inicia sesión',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const SectionHeading('¿Por qué elegir HiDoc?'),
                  const SizedBox(height: 10),

                  const BenefitTile(
                    icon: Icons.verified_user,
                    title: 'Médicos certificados',
                    subtitle: 'Profesionales validados y especializados',
                    colorSeed: Color(0xFF4D8AF0),
                  ),
                  const SizedBox(height: 10),
                  const BenefitTile(
                    icon: Icons.schedule,
                    title: 'Disponible 24/7',
                    subtitle: 'Atención médica cuando la necesites',
                    colorSeed: Color(0xFF29C18B),
                  ),
                  const SizedBox(height: 10),
                  const BenefitTile(
                    icon: Icons.shield,
                    title: 'Datos Seguros',
                    subtitle: 'Tu información médica protegida',
                    colorSeed: Color(0xFF4F6BFF),
                  ),

                  const Spacer(),
                  const SizedBox(height: 14),
                  Center(
                    child: Text(
                      'Tu salud es nuestra prioridad',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}