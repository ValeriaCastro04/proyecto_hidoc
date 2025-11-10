// models/patient.dart
class Patient {
  final String id; // UUID
  final String name;
  final String lastName;
  final String? email;
  final DateTime birthDate;
  final String? phone;
  // Añade otros campos si los necesitas en la UI

  Patient({
    required this.id,
    required this.name,
    required this.lastName,
    this.email,
    required this.birthDate,
    this.phone,
  });

  // Método para combinar nombre y apellido
  String get fullName => '$name $lastName';

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      lastName: json['lastName'],
      email: json['email'],
      birthDate: DateTime.parse(json['birthDate']),
      phone: json['phone'],
    );
  }
}