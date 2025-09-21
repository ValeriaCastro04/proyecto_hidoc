import 'package:flutter/material.dart';

enum UserRole { patient, doctor }

class SegmentedRoleToggle extends StatelessWidget {
  final UserRole value;
  final ValueChanged<UserRole> onChanged;

  const SegmentedRoleToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: cs.outline.withOpacity(0.25), width: 1.6),
    );

    return Container(
      decoration: ShapeDecoration(
        shape: border,
        color: cs.onPrimary, // fondo claro
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          _pill(
            context,
            label: 'Paciente',
            icon: Icons.person_rounded,
            selected: value == UserRole.patient,
            onTap: () => onChanged(UserRole.patient),
          ),
          const SizedBox(width: 6),
          _pill(
            context,
            label: 'Médico',
            icon: Icons.medical_services_rounded,
            selected: value == UserRole.doctor,
            onTap: () => onChanged(UserRole.doctor),
          ),
        ],
      ),
    );
  }

  Widget _pill(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: selected ? cs.onPrimary : cs.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: selected ? cs.onPrimary : cs.primary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}