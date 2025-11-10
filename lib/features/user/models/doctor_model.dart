class DoctorLite {
  final String id;
  final String fullName;
  final String specialty;
  final int price;
  final double rating;
  final bool isOnline;

  DoctorLite({
    required this.id,
    required this.fullName,
    required this.specialty,
    required this.price,
    required this.rating,
    required this.isOnline,
  });

  factory DoctorLite.fromMap(Map<String, dynamic> j) {
    // rating puede venir como "0.00" (string) o número
    final rRaw = j['rating'];
    final r = switch (rRaw) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0.0,
      _ => 0.0,
    };

    return DoctorLite(
      id: (j['id'] ?? '').toString(),
      fullName: (j['fullName'] ?? j['fullname'] ?? '').toString(),
      specialty: (j['specialty'] ?? '').toString(),
      price: int.tryParse('${j['price'] ?? 0}') ?? 0,
      rating: r,
      isOnline: (j['isOnline'] ?? false) == true,
    );
  }
}

class AvailabilitySlot {
  final DateTime start;
  final DateTime end;
  final bool isBooked;

  AvailabilitySlot({
    required this.start,
    required this.end,
    required this.isBooked,
  });

  factory AvailabilitySlot.fromMap(Map<String, dynamic> j) {
    // backend puede mandar keys diferentes según el endpoint
    final start = DateTime.parse((j['start'] ?? j['startISO']).toString());
    final end   = DateTime.parse((j['end']   ?? j['endISO']).toString());
    final booked = (j['isBooked'] ?? false) == true;
    return AvailabilitySlot(start: start, end: end, isBooked: booked);
  }
}