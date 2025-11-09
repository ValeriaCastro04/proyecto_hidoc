class DoctorLite {
  final String id;
  final String fullName;
  final String specialty; // si tu API no lo manda, mostramos un genérico
  final double rating;    // si no tienes ratings aún, 5.0 por defecto
  final num price;        // requerido por la UI
  final DateTime? createdAt;
  final bool? isSeeded;   // si algún día lo expones en API

  DoctorLite({
    required this.id,
    required this.fullName,
    required this.specialty,
    required this.rating,
    required this.price,
    this.createdAt,
    this.isSeeded,
  });

  factory DoctorLite.fromJson(Map<String, dynamic> j) => DoctorLite(
        id: j['id'] as String,
        fullName: (j['fullName'] ?? j['name'] ?? 'Doctor/a') as String,
        specialty: (j['specialty'] ?? j['mainSpecialty'] ?? 'Medicina') as String,
        rating: (j['rating'] == null) ? 5.0 : (j['rating'] as num).toDouble(),
        price: (j['price'] ?? 10) as num,
        createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt']) : null,
        isSeeded: j['isSeeded'] as bool?,
      );
}

class AvailabilitySlot {
  final DateTime start;
  final DateTime end;
  final bool isBooked;
  AvailabilitySlot({required this.start, required this.end, required this.isBooked});

  factory AvailabilitySlot.fromJson(Map<String, dynamic> j) => AvailabilitySlot(
        start: DateTime.parse(j['start']),
        end: DateTime.parse(j['end']),
        isBooked: j['isBooked'] as bool? ?? false,
      );
}