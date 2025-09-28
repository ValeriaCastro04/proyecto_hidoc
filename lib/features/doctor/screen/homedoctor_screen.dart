import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/common/shared_widgets/outline_button_grid.dart'; 
import 'package:proyecto_hidoc/features/doctor/widgets/list/quick_actions_doctor.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/footer_doctor.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/header_doctor.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/summary_card.dart';
import 'package:proyecto_hidoc/common/shared_widgets/recent_activity.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/activities.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/summary_card_list.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';

class HomeDoctorScreen extends StatelessWidget {
  static const String name = 'homedoctor_screen';
  const HomeDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const String name = 'Dra. Elena Martínez';
    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: name,
        actions: [
          ThemeToggleButton(), 
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            child: Text(
              name.split(' ').map((e) => e[0]).take(2).join(),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Column(
              children: [
                HomeHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -20),
                        child: DoctorSummaryCard(items: summaryItems),
                      ),
                      RecentActivityCard(activities: activities),
                      const SizedBox(height: 20),
                      OutlineButtonGrid(
                        title: 'Acciones Rápidas',
                        buttons: doctorButtons(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons(context)),
    );
  }
}
