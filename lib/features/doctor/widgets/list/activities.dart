import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/global_widgets/activity_item.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/patients.dart';

final activities = [
  Activity(
    icon: Icons.receipt_long_rounded,
    iconBackground: Colors.blue.withOpacity(0.1),
    iconColor: Colors.blue,
    title: 'Receta Digital',
    subtitle: Patients[0]["name"]!, // Paciente 0
    badgeText: '2h',
    badgeColor: Colors.blue.withOpacity(0.15),
    badgeTextColor: Colors.blue,
  ),
  Activity(
    icon: Icons.check_circle_outline_rounded,
    iconBackground: Colors.green.withOpacity(0.1),
    iconColor: Colors.green,
    title: 'Consulta Completada',
    subtitle: Patients[1]["name"]!, // Paciente 1
    badgeText: 'Ayer',
    badgeColor: Colors.green.withOpacity(0.15),
    badgeTextColor: Colors.green,
  ),
  Activity(
    icon: Icons.medical_services_outlined,
    iconBackground: Colors.purple.withOpacity(0.1),
    iconColor: Colors.purple,
    title: 'Examen de Laboratorio',
    subtitle: Patients[2]["name"]!, // Paciente 2
    badgeText: '3d',
    badgeColor: Colors.purple.withOpacity(0.15),
    badgeTextColor: Colors.purple,
  ),
];
