// models/cita_doctor.dart
import 'patient.dart';

class CitaDoctor {
  final String id;
  final DateTime start; // Recibimos UTC
  final DateTime end;   // Recibimos UTC
  final String reason;
  final String? note;
  final Patient? patient; // El paciente viene anidado

  CitaDoctor({
    required this.id,
    required this.start,
    required this.end,
    required this.reason,
    this.note,
    this.patient,
  });

  factory CitaDoctor.fromJson(Map<String, dynamic> json) {
    return CitaDoctor(
      id: json['id'],
      start: DateTime.parse(json['start']), // Se parsea el string ISO
      end: DateTime.parse(json['end']),
      reason: json['reason'],
      note: json['note'],
      patient: json['patient'] != null 
          ? Patient.fromJson(json['patient']) 
          : null,
    );
  }
}