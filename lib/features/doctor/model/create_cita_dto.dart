import 'dart:convert';

// Data Transfer Object (DTO) para enviar a la API
class CreateCitaDoctorDto {
  final String patientId;
  final String reason;
  final DateTime start; 
  final DateTime end;   
  final String? note;

  CreateCitaDoctorDto({
    required this.patientId,
    required this.reason,
    required this.start,
    required this.end,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'reason': reason,
      'start': start.toIso8601String(), 
      'end': end.toIso8601String(),
      'note': note,
    };
  }

  String toJson() => json.encode(toMap());
}