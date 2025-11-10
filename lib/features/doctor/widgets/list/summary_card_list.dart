import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/summary_card.dart';

final List<SummaryItem> summaryItems = [
  SummaryItem(
    icon: Icons.calendar_month_rounded,
    label: 'Consultas Hoy',
    value: '20',
  ),
  SummaryItem(
    icon: Icons.star_rounded,
    label: 'Calificación',
    value: '0.0',
  ),
];
