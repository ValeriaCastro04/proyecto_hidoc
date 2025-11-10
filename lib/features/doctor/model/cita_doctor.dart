import 'patient.dart';

class CitaDoctor {
  final String id;
  final DateTime start; 
  final DateTime end;   
  final String reason;
  final String? note;
  final Patient? patient;

  CitaDoctor({
    required this.id,
    required this.start,
    required this.end,
    required this.reason,
    this.note,
    this.patient,
  });

  //convertir desde json a objeto
  factory CitaDoctor.fromJson(Map<String, dynamic> json) {
    return CitaDoctor(
      id: json['id'],
      start: DateTime.parse(json['start']), 
      end: DateTime.parse(json['end']),
      reason: json['reason'],
      note: json['note'],
      patient: json['patient'] != null 
          ? Patient.fromJson(json['patient']) 
          : null,
    );
  }
}