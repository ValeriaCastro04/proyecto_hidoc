import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/global_widgets/activity_item.dart';

final activities = [
  Activity(
    icon: Icons.receipt_long_rounded,
    iconBackground: Colors.blue.withOpacity(0.1),
    iconColor: Colors.blue,
    title: 'Receta Digital',
    subtitle: 'Dr. María López',
    badgeText: '2h',
    badgeColor: Colors.blue.withOpacity(0.15),
    badgeTextColor: Colors.blue,
  ),
  Activity(
    icon: Icons.check_circle_outline_rounded,
    iconBackground: Colors.green.withOpacity(0.1),
    iconColor: Colors.green,
    title: 'Consulta Completada',
    subtitle: 'Dr. Carlos Ruiz',
    badgeText: 'Ayer',
    badgeColor: Colors.green.withOpacity(0.15),
    badgeTextColor: Colors.green,
  ),
];
