import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/global_widgets/activity_item.dart';

class RecentActivityCard extends StatelessWidget {
  final List<Activity> activities;

  const RecentActivityCard({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actividad Reciente',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          ...activities.map(
            (activity) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ActivityItem(
                icon: activity.icon,
                iconBackground: activity.iconBackground,
                iconColor: activity.iconColor,
                title: activity.title,
                subtitle: activity.subtitle,
                badgeText: activity.badgeText,
                badgeColor: activity.badgeColor,
                badgeTextColor: activity.badgeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
