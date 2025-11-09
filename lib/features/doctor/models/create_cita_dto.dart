class CreateCitaDoctorDto {
  final String patientId; // UUID
  final DateTime start;   // Lo convertiremos a ISO
  final DateTime end;     // Lo convertiremos a ISO
  final String reason;
  final String? note;

  CreateCitaDoctorDto({
    required this.patientId,
    required this.start,
    required this.end,
    required this.reason,
    this.note,
  });

  // Convierte nuestro objeto Dart a un Map, dio lo codificará a JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'patientId': patientId,
      'start': start.toIso8601String(), // NestJS espera IsDateString
      'end': end.toIso8601String(),
      'reason': reason,
    };
    if (note != null) {
      data['note'] = note;
    }
    return data;
  }
}