import 'package:proyecto_hidoc/common/global_widgets/outline_button.dart';  
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<Widget> doctorButtons(BuildContext context) {
  
  return [
    OutlineButton(
      onPressed: () => context.go('/nueva_cita'),
      text: 'Nueva Cita',
      icon: Icons.note_add,
    ),
    OutlineButton(
      onPressed: () => context.go('/pacientes'),
      text: 'Pacientes',
      icon: Icons.people,
    ),
    OutlineButton(
      onPressed: () => context.go('/reportes'),
      text: 'Estadísticas',
      icon: Icons.show_chart,
    ),
    OutlineButton(
      onPressed: () => context.go('/agenda'),
      text: 'Agenda',
      icon: Icons.calendar_today,
    ),
  ];
}
