import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/features/user/models/doctor_category.dart';
import 'package:proyecto_hidoc/features/user/pages/doctores_disponibles.dart';

class QuickActionsUser extends StatelessWidget {
  final List<DoctorCategoryDto> categories;
  const QuickActionsUser({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Text(
        'No hay categorías disponibles por ahora',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    // Tomamos solo las 3 primeras si hubiera más
    final items = categories.take(3).toList();

    return LayoutBuilder(
      builder: (context, c) {
        final isNarrow = c.maxWidth < 520; // web/chrome suele ser ancho; ajustamos por si acaso
        return Row(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              Expanded(
                child: _ActionCard(
                  title: items[i].name ?? items[i].code,
                  icon: Icons.medical_services_rounded,
                  onTap: () {
                    context.pushNamed(
                      DoctoresDisponiblesPage.name,
                      queryParameters: {
                        'categoryCode': items[i].code,        // GENERAL | ESPECIALIZADA | PEDIATRIA
                        'categoryName': items[i].name ?? '',  // Etiqueta legible
                      },
                    );
                  },
                ),
              ),
              if (i != items.length - 1) SizedBox(width: isNarrow ? 10 : 16),
            ],
          ],
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 92), // ↑ un poco más alto para evitar overflow
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: cs.outline.withOpacity(.15)),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: cs.primary),
              ),
              const SizedBox(height: 8),
              // Texto en 2 líneas máximo y centrado: sin overflow rojo
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}