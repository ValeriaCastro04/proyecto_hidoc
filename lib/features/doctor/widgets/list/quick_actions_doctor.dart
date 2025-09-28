import 'package:proyecto_hidoc/common/global_widgets/outline_button.dart';  
import 'package:flutter/material.dart';

final List<Widget> doctorButtons = [
      OutlineButton(
        onPressed: () {
          print('Nueva Cita');
        },
        text: 'Nueva Cita',
        icon: Icons.note_add,
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
