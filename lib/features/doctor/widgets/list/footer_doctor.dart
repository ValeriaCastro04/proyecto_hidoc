import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/common/global_widgets/footer.dart';

List<Widget> doctorFooterButtons(BuildContext context) {
  // Obtiene ruta actual
  final String currentRoute = GoRouterState.of(context).matchedLocation;

  return [
    FooterButton(
      onPressed: () => context.go('/home_doctor'),
      text: 'Inicio',
      icon: Icons.home,
      isActive: currentRoute == '/home_doctor',
    ),
    FooterButton(
      onPressed: () => context.go('/agenda'),
      text: 'Agenda',
      icon: Icons.calendar_today,
      isActive: currentRoute == '/agenda',
    ),
    FooterButton(
      onPressed: () => context.go('/pacientes'),
      text: 'Pacientes',
      icon: Icons.people,
      isActive: currentRoute == '/pacientes',
    ),
    FooterButton(
      onPressed: () => context.go('/reportes'),
      text: 'Reportes',
      icon: Icons.bar_chart,
      isActive: currentRoute == '/reportes',
    ),
  ];
}
