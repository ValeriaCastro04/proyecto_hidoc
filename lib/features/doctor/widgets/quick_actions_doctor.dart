import 'package:proyecto_hidoc/common/global_widgets/outline_button.dart'; // Asegúrate de que la ruta sea correcta
import 'package:flutter/material.dart';

final List<Widget> doctorButtons = [
      OutlineButton(
        onPressed: () {
          print('Nueva Receta');
        },
        text: 'Nueva Receta',
        icon: Icons.description,
      ),
      OutlineButton(
        onPressed: () {
          print('Pacientes');
        },
        text: 'Pacientes',
        icon: Icons.people,
      ),
      OutlineButton(
        onPressed: () {
          print('Estadísticas');
        },
        text: 'Estadísticas',
        icon: Icons.show_chart,
      ),
      OutlineButton(
        onPressed: () {
          print('Agenda');
        },
        text: 'Agenda',
        icon: Icons.calendar_today,
      ),
    ];
