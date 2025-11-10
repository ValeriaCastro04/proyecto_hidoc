// lib/features/doctor/models/create_cita_dto.dart
import 'dart:convert';

// Data Transfer Object (DTO) para enviar a la API
class CreateCitaDoctorDto {
  final String patientId;
  final String reason;
  final DateTime start; // <-- CAMBIADO de 'date' a 'start'
  final DateTime end;   // <-- AÑADIDO 'end'
  final String? note;

  CreateCitaDoctorDto({
    required this.patientId,
    required this.reason,
    required this.start, // <-- CAMBIADO
    required this.end,   // <-- AÑADIDO
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'reason': reason,
      'start': start.toIso8601String(), // Enviar en formato ISO
      'end': end.toIso8601String(),     // Enviar en formato ISO
      'note': note,
    };
  }

  String toJson() => json.encode(toMap());
}