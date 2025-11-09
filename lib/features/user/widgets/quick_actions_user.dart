import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_hidoc/features/user/pages/doctores_disponibles.dart';
import 'package:proyecto_hidoc/features/user/models/doctor_category.dart';

class QuickActionsUser extends StatelessWidget {
  final List<DoctorCategoryDto> categories;
  const QuickActionsUser({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    if (categories.isEmpty) {
      return Text('No hay categorías disponibles por ahora', style: tt.bodyMedium);
    }

    final items = categories.take(3).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((c) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => context.pushNamed(
                DoctoresDisponiblesPage.name,
                queryParameters: {'categoryCode': c.code, 'categoryName': c.name},
              ),
              child: Container(
                height: 84,
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cs.outline.withOpacity(.12)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.medical_services_rounded, color: cs.primary),
                    const SizedBox(height: 6),
                    Text(c.name, style: tt.labelLarge?.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}