class DoctorCategoryDto {
  final String id;
  final String code;
  final String name;
  final String? description;

  DoctorCategoryDto({
    required this.id,
    required this.code,
    required this.name,
    this.description,
  });

  /// Convierte un JSON (Map) en una instancia de DoctorCategoryDto
  factory DoctorCategoryDto.fromMap(Map<String, dynamic> j) {
    return DoctorCategoryDto(
      id: (j['id'] ?? '').toString(),
      code: (j['code'] ?? '').toString(),
      name: (j['name'] ?? j['categoryName'] ?? '').toString(),
      description: j['description']?.toString(),
    );
  }

  /// Convierte una lista dinámica (List<Map>) en una lista de DoctorCategoryDto
  static List<DoctorCategoryDto> fromList(dynamic data) {
    if (data is List) {
      return data.map((e) => DoctorCategoryDto.fromMap(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  /// Convierte el objeto a JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        if (description != null) 'description': description,
      };

  @override
  String toString() => 'DoctorCategoryDto(code: $code, name: $name)';
}