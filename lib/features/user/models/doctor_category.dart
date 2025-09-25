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

  static DoctorCategory fromPath(String? v) {
    return switch (v) {
      'especializada' => DoctorCategory.especializada,
      'pediatrica' => DoctorCategory.pediatrica,
      _ => DoctorCategory.general, // default
    };
  }
}