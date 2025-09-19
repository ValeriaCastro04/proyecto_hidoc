import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/global_widgets/footer.dart';
import 'package:go_router/go_router.dart';

List<Widget> doctorFooterButtons(BuildContext context) {
  return [
    FooterButton(
      onPressed: () {
        context.go('/home_doctor');
        print('Inicio');
      },
      text: 'Inicio',
      icon: Icons.home,
    ),
    FooterButton(
      onPressed: () {
        context.go('/agenda');
        print('Agenda');
      },
      text: 'Agenda',
      icon: Icons.calendar_today,
    ),
    FooterButton(
      onPressed: () {
        context.go('/pacientes');
        print('Pacientes');
      },
      text: 'Pacientes',
      icon: Icons.people,
    ),
    FooterButton(
      onPressed: () {
        context.go('/reportes');
        print('Reportes');
      },
      text: 'Reportes',
      icon: Icons.bar_chart,
    ),
  ];
}

