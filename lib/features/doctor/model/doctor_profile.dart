import 'dart:convert';

class DoctorProfile {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? specialty;
  final String? bio;
  final int patientCount;

  DoctorProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.specialty,
    this.bio,
    required this.patientCount,
  });

  //conversión desde json
  factory DoctorProfile.fromJson(Map<String, dynamic> map) {
    return DoctorProfile(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      specialty: map['specialty'] as String?,
      bio: map['bio'] as String?,
      patientCount: map['patientCount'] as int? ?? 0,
    );
  }

  factory DoctorProfile.fromJsonString(String source) =>
      DoctorProfile.fromJson(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'specialty': specialty,
      'bio': bio,
    };
  }

  String toJson() => json.encode(toMap());
}