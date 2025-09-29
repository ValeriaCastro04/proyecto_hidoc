import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/footer_doctor.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/summary_card.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/summary_card_list.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/patient_comment.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/montly_income_card.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/doctor.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/doctor_infor.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/doctor_schedule.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/doctor_studies.dart';

class ReportesScreen extends StatelessWidget {
  static const String name = 'reportes_screen';
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final doctor = Doctor[0]; // Tomamos el primer doctor
    final profileTabs = doctor['profile_tabs'];
    final String doctorName = doctor['name'];

    // Ingresos simulados
    final List<double> ingresos = [
      3000, 3200, 2800, 3500, 4000, 4200,
      3800, 4500, 4300, 4700, 5000, 4800,
    ];

    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: doctorName,
        actions: [
          ThemeToggleButton(),
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
              doctorName.split(' ').map((e) => e[0]).take(2).join(),
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
              // Información del doctor desde la lista
              InfoTab(doctor: doctor),
              const SizedBox(height: 16),

              // Resumen de reportes
              DoctorSummaryCard(items: reportSummaryItems),
              const SizedBox(height: 16),

              // Horario del doctor
              ScheduleTab(schedule: profileTabs['schedule']),
              const SizedBox(height: 16),

              // Diplomas del doctor
              DiplomasTab(diplomas: profileTabs['diplomas']), 
              const SizedBox(height: 16),

              // Comentarios de pacientes dinámicos
              PatientCommentsCard(
                title: "Reseñas de Pacientes",
                comments: profileTabs['reviews'],
              ),
              const SizedBox(height: 16),

              // Gráfica de ingresos
              MonthlyIncomeChart(monthlyIncome: ingresos),
              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons(context)),
    );
  }
}
