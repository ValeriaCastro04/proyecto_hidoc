import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/common/global_widgets/footer.dart';

/// Botones del footer para el flujo de **Paciente**
List<Widget> userFooterButtons(BuildContext context) {
  return [
    FooterButton(
      onPressed: () {
        context.go('/home_user');
        // print('Inicio');
      },
      text: 'Inicio',
      icon: Icons.home_rounded,
    ),
    FooterButton(
      onPressed: () {
        context.go('/consultas');
        // print('Consultas');
      },
      text: 'Consultas',
      icon: Icons.event_note_rounded,
    ),
    FooterButton(
      onPressed: () {
        context.go('/historial');
        // print('Historial');
      },
      text: 'Historial',
      icon: Icons.history_rounded,
    ),
    FooterButton(
      onPressed: () {
        context.go('/perfil');
        // print('Perfil');
      },
      text: 'Perfil',
      icon: Icons.person_rounded,
    ),
  ];
}