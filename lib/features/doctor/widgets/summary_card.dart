import 'package:flutter/material.dart';

/// Modelo de información de cada métrica
class SummaryItem {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });
}

/// Widget reutilizable de tarjeta resumen
class DoctorSummaryCard extends StatelessWidget {
  final List<SummaryItem> items;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const DoctorSummaryCard({
    super.key,
    required this.items,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: colorScheme.outlineVariant.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                color: item.iconColor ?? colorScheme.primary,
                size: 36,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.value,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    item.label,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
