import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer.dart';

/// Identificador de la pestaña activa del footer de Paciente
enum UserTab { home, consultas, historial, perfil }

/// Construye los botones del footer marcando la pestaña [current] como seleccionada
List<Widget> userFooterButtons(
  BuildContext context, {
  required UserTab current,
}) {
  return [
    FooterButton(
      onPressed: () => context.go('/home_user'),
      text: 'Inicio',
      icon: Icons.home_rounded,
      selected: current == UserTab.home,
    ),
    FooterButton(
      onPressed: () => context.go('/consultas'),
      text: 'Consultas',
      icon: Icons.event_note_rounded,
      selected: current == UserTab.consultas,
    ),
    FooterButton(
      onPressed: () => context.go('/historial'),
      text: 'Historial',
      icon: Icons.history_rounded,
      selected: current == UserTab.historial,
    ),
    FooterButton(
      onPressed: () => context.go('/perfil'),
      text: 'Perfil',
      icon: Icons.person_rounded,
      selected: current == UserTab.perfil,
    ),
  ];
}