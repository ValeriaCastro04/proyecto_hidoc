/// Tipo de pago (consulta o membresía)
enum PaymentKind {
  /// Pago por consulta médica individual
  consulta,
  
  /// Pago por membresía
  membresia
}

/// Método de pago disponible
enum PayMethod {
  /// Pago con tarjeta
  card,
  
  /// Pago con Tigo Money
  tigo
}