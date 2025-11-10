import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/features/user/models/doctor_category.dart';

/// Muestra accesos rápidos a las categorías de doctores.
/// Espera codigos: GENERAL | ESPECIALIZADA | PEDIATRIA
class QuickActionsUser extends StatelessWidget {
  final List<DoctorCategoryDto> categories;

  const QuickActionsUser({super.key, required this.categories});

  // Orden fijo de cómo queremos mostrarlas
  int _orderKey(String code) {
    switch (code.toUpperCase()) {
      case 'GENERAL':
        return 1;
      case 'ESPECIALIZADA':
        return 2;
      case 'PEDIATRIA':
        return 3;
      default:
        return 99;
    }
  }

  String _pathFromCode(String code) {
    switch (code.toUpperCase()) {
      case 'GENERAL':
        return 'general';
      case 'ESPECIALIZADA':
        return 'especializada';
      case 'PEDIATRIA':
        return 'pediatrica';
      default:
        return code.toLowerCase();
    }
  }

  IconData _iconFromCode(String code) {
    switch (code.toUpperCase()) {
      case 'GENERAL':
        return Icons.medical_services_rounded;
      case 'ESPECIALIZADA':
        return Icons.add_circle_outline_rounded;
      case 'PEDIATRIA':
        return Icons.child_care_rounded;
      default:
        return Icons.local_hospital_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    if (categories.isEmpty) {
      return Text('No hay categorías disponibles por ahora',
          style: tt.bodyMedium);
    }

    // Ordenamos y tomamos hasta 3 (si vienen más)
    final items = [...categories]..sort((a, b) => _orderKey(a.code).compareTo(_orderKey(b.code)));

    return LayoutBuilder(
      builder: (context, constraints) {
        // Tres columnas equilibradas
        return Row(
          children: List.generate(items.length.clamp(0, 3), (i) {
            final c = items[i];
            return Expanded(
              child: _ActionCard(
                icon: _iconFromCode(c.code),
                label: c.name,
                onTap: () => context.push('/consultas/${_pathFromCode(c.code)}'),
              ),
            );
          }),
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 104, // extra alto para evitar “bottom overflowed”
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outline.withOpacity(.15)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: cs.primary),
              ),
              const SizedBox(height: 8),
              // Dos líneas máximo, sin overflow
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}