import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/common/shared_widgets/outline_button_grid.dart'; 
import 'package:proyecto_hidoc/features/doctor/widgets/quick_actions_doctor.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/footer_doctor.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/header_doctor.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/summary_card.dart';
import 'package:proyecto_hidoc/common/shared_widgets/recent_activity.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/activities.dart';

class HomeDoctorScreen extends StatelessWidget {
  static const String name = 'homedoctor_screen';
  const HomeDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: 'Dra. Elena Martínez',
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Text('EM'),
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
                        child: DoctorSummaryCard(
                          todayConsults: 20,
                          rating: 4.5,
                        ),
                      ),
                      RecentActivityCard(activities: activities),
                      const SizedBox(height: 20),
                      OutlineButtonGrid(
                        title: 'Acciones Rápidas',
                        buttons: doctorButtons,
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
