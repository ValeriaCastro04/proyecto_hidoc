// lib/features/doctor/widgets/new_appointment_form.dart
import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/patients.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/appointments.dart';

class NewAppointmentForm extends StatefulWidget {
  final DateTime initialDay;

  const NewAppointmentForm({super.key, required this.initialDay});

  @override
  State<NewAppointmentForm> createState() => _NewAppointmentFormState();
}

class _NewAppointmentFormState extends State<NewAppointmentForm> {
  int? _selectedPatient;
  String _reason = '';
  DateTime? _selectedDate;
  int? _selectedHour;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDay; // por defecto el día actual
  }

  void _saveAppointment() {
    if (_selectedPatient == null || _reason.isEmpty || _selectedDate == null || _selectedHour == null) {
      return;
    }

    final newAppointment = {
      "patientId": _selectedPatient,
      "reason": _reason,
      "timeStart": _selectedHour,
      "timeEnd": _selectedHour! + 1,
      "color": Colors.blue,
    };

    final day = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
    );

    if (!mockAppointmentsByDate.containsKey(day)) {
      mockAppointmentsByDate[day] = [];
    }
    mockAppointmentsByDate[day]!.add(newAppointment);

    Navigator.pop(context, true); // devolvemos true para refrescar
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Nueva Cita",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),

            // Paciente
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Paciente"),
              items: Patients.asMap().entries.map((entry) {
                final idx = entry.key;
                final patient = entry.value;
                return DropdownMenuItem<int>(
                  value: idx,
                  child: Text(patient['name']!),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedPatient = val),
            ),

            // Razón
            TextFormField(
              decoration: const InputDecoration(labelText: "Razón / Descripción"),
              onChanged: (val) => _reason = val,
            ),

            const SizedBox(height: 16),

            // Fecha
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? "Seleccionar día"
                        : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  child: const Text("Elegir día"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Hora (solo redondas)
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Hora"),
              items: List.generate(10, (i) => i + 8).map((hour) {
                return DropdownMenuItem<int>(
                  value: hour,
                  child: Text("${hour.toString().padLeft(2, '0')}:00"),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedHour = val),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _saveAppointment,
              icon: const Icon(Icons.check),
              label: const Text("Guardar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
