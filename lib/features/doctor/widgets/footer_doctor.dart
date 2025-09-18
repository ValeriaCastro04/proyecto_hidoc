import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/global_widgets/footer.dart'; // Asegúrate de que la ruta sea correcta

final List<Widget> doctorFooterButtons = [
  FooterButton(
    onPressed: () {
      print('Inicio');
    },
    text: 'Inicio',
    icon: Icons.home,
  ),
  FooterButton(
    onPressed: () {
      print('Agenda');
    },
    text: 'Agenda',
    icon: Icons.calendar_today,
  ),
  FooterButton(
    onPressed: () {
      print('Pacientes');
    },
    text: 'Pacientes',
    icon: Icons.people,
  ),
  FooterButton(
    onPressed: () {
      print('Reportes');
    },
    text: 'Reportes',
    icon: Icons.bar_chart,
  ),
];