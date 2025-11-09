enum DoctorCategory { general, especializada, pediatrica }

extension DoctorCategoryX on DoctorCategory {
  String get path => switch (this) {
        DoctorCategory.general => 'general',
        DoctorCategory.especializada => 'especializada',
        DoctorCategory.pediatrica => 'pediatrica',
      };

  String get title => switch (this) {
        DoctorCategory.general => 'Consulta General',
        DoctorCategory.especializada => 'Consulta Especializada',
        DoctorCategory.pediatrica => 'Consulta Pediátrica',
      };

  /// CODE que espera la API (según tu tabla: GENERAL, ESPECIALIZADA, PEDIATRIA)
  String get apiCode => switch (this) {
        DoctorCategory.general => 'GENERAL',
        DoctorCategory.especializada => 'ESPECIALIZADA',
        DoctorCategory.pediatrica => 'PEDIATRIA',
      };

  static DoctorCategory fromPath(String? v) {
    return switch (v) {
      'especializada' => DoctorCategory.especializada,
      'pediatrica' => DoctorCategory.pediatrica,
      _ => DoctorCategory.general,
    };
  }
}

/// DTO que viene de /v1/doctors/categories
class DoctorCategoryDto {
  final String id;
  final String code; // GENERAL | ESPECIALIZADA | PEDIATRIA
  final String name; // "Medicina General", etc.

  DoctorCategoryDto({required this.id, required this.code, required this.name});

  factory DoctorCategoryDto.fromJson(Map<String, dynamic> j) => DoctorCategoryDto(
        id: j['id'] as String,
        code: j['code'] as String,
        name: j['name'] as String,
      );

  /// Mapa útil si quieres convertir a tu enum (opcional)
  DoctorCategory toEnum() {
    switch (code) {
      case 'ESPECIALIZADA':
        return DoctorCategory.especializada;
      case 'PEDIATRIA':
        return DoctorCategory.pediatrica;
      default:
        return DoctorCategory.general;
    }
  }
}