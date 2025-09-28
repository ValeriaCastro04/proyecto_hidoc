import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/footer_doctor.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/summary_card.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/summary_card_list.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/patient_comment.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/info_card.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/montly_income_card.dart';

class ReportesScreen extends StatelessWidget {
  static const String name = 'reportes_screen';
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final List<double> ingresos = [
      3000, 3200, 2800, 3500, 4000, 4200,
      3800, 4500, 4300, 4700, 5000, 4800,
    ];
    const String name = 'Dra. Elena Martínez';
    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: name,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_rounded,
              color: colors.onSurface,
            ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Información del doctor
              DoctorInfoCard(
                name: 'Dra. Elena Martínez',
                specialty: 'Medicina General',
                yearsExperience: 12,
                email: 'elena.martinez@email.com',
              ),
              const SizedBox(height: 16),
              DoctorSummaryCard(items: reportSummaryItems),
              const SizedBox(height: 16),
              
              MonthlyIncomeChart(monthlyIncome: ingresos),
              const SizedBox(height: 16),

              // Comentarios de pacientes
              PatientCommentsCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons(context)),
    );
  }
} 