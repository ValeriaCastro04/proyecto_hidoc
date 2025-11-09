// lib/common/shared_widgets/segmented_role_toggle.dart
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

    Widget segment({
      required bool selected,
      required IconData icon,
      required String label,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: selected ? cs.primary.withOpacity(.12) : cs.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? cs.primary : cs.outline.withOpacity(.35),
                width: selected ? 1.5 : 1,
              ),
            ),
            // FittedBox: evita overflow en anchos pequeños
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: selected ? cs.primary : cs.onSurface.withOpacity(.8),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: selected ? cs.primary : cs.onSurface.withOpacity(.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        segment(
          selected: value == UserRole.patient,
          icon: Icons.person_rounded,
          label: 'Paciente',
          onTap: () => onChanged(UserRole.patient),
        ),
        const SizedBox(width: 12),
        segment(
          selected: value == UserRole.doctor,
          icon: Icons.medical_services_rounded,
          label: 'Médico',
          onTap: () => onChanged(UserRole.doctor),
        ),
      ],
    );
  }
}