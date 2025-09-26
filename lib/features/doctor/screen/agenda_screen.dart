import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/footer_doctor.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/appointments.dart';

class AgendaScreen extends StatelessWidget {
  static const String name = 'agenda_screen';
  const AgendaScreen({super.key});

  Widget _buildAppointmentCard(BuildContext context, Map<String, dynamic> appointment) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      height: 90.0 * (appointment['timeEnd'] - appointment['timeStart']),
      decoration: BoxDecoration(
        color: appointment['color'].withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            appointment['patientName'],
            style: TextStyle(
              color: colors.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          if ((appointment['reason'] as String).isNotEmpty)
            Text(
              appointment['reason'],
              style: TextStyle(
                color: colors.onPrimary.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          Text(
            '${appointment['timeStart'].toString().padLeft(2, '0')}:00 - ${appointment['timeEnd'].toString().padLeft(2, '0')}:00',
            style: TextStyle(
              color: colors.onPrimary.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourSlot(BuildContext context, int hour) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 70,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.onBackground.withOpacity(0.2))),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '${hour.toString().padLeft(2, '0')}:00',
          style: TextStyle(
            color: colors.onBackground.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agenda del Doctor',
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 24,
        itemBuilder: (context, index) {
          final appointment = mockAppointments.firstWhere(
            (a) => index >= a['timeStart'] && index < a['timeEnd'],
            orElse: () => {},
          );

          return appointment.isNotEmpty
              ? _buildAppointmentCard(context, appointment)
              : _buildHourSlot(context, index);
        },
      ),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons(context)),
    );
  }
}
