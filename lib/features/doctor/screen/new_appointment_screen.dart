// lib/features/doctor/widgets/new_appointment_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- 1. Importar Riverpod
// <-- 2. Importar Providers y Modelos
import '../../../main.dart';
import '../models/patient.dart';
import '../models/create_cita_dto.dart';

// <-- 3. Cambiar a ConsumerStatefulWidget
class NewAppointmentForm extends ConsumerStatefulWidget {
  final DateTime initialDay;

  const NewAppointmentForm({
    super.key,
    required this.initialDay,
  });

  @override
  ConsumerState<NewAppointmentForm> createState() => _NewAppointmentFormState();
}

// <-- 4. Cambiar a ConsumerState
class _NewAppointmentFormState extends ConsumerState<NewAppointmentForm> {
  // --- 5. Estados para cargar pacientes de la API ---
  bool _isLoadingPatients = true;
  List<Patient> _patients = [];
  String? _patientLoadError;

  // --- Estados del formulario ---
  String? _selectedPatientId; // <-- 6. Cambiado de int a String?
  String _reason = '';
  DateTime? _selectedDate;
  double? _selectedStartHour;
  double? _selectedEndHour;
  String? _timeError;
  bool _isSaving = false; // Para feedback de guardado

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDay;
    _fetchPatients(); // <-- 7. Cargar pacientes al iniciar
  }

  /// 8. Carga los pacientes desde la API
  Future<void> _fetchPatients() async {
    setState(() => _isLoadingPatients = true);
    try {
      // Usa ref.read() para obtener el servicio
      final patientList = await ref.read(apiServiceProvider).getPatients();
      setState(() {
        _patients = patientList;
        _isLoadingPatients = false;
      });
    } catch (e) {
      setState(() {
        _patientLoadError = e.toString();
        _isLoadingPatients = false;
      });
    }
  }

  /// 9. Guarda la cita en la API
  Future<void> _saveAppointment() async {
    setState(() => _timeError = null);

    // Validar campos requeridos
    if (_selectedPatientId == null || // <-- 10. Validar el ID
        _reason.isEmpty ||
        _selectedDate == null ||
        _selectedStartHour == null ||
        _selectedEndHour == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    // Validar que la hora final sea posterior
    if (_selectedEndHour! <= _selectedStartHour!) {
      setState(() {
        _timeError = "La hora de fin debe ser posterior a la hora de inicio.";
      });
      return;
    }

    // Tu validación de 30-60 min
    final duration = _selectedEndHour! - _selectedStartHour!;
    if (duration != 0.5 && duration != 1.0) {
      setState(() {
        _timeError = "La cita debe durar 30 o 60 minutos.";
      });
      return;
    }

    setState(() => _isSaving = true);

    try {
      // --- 11. TRADUCCIÓN DE DATOS (Formulario a DTO) ---
      // Combina la fecha seleccionada con las horas decimales
      
      final int startHour = _selectedStartHour!.floor();
      final int startMinute = ((_selectedStartHour! - startHour) * 60).round();
      // Crea el DateTime local
      final DateTime startTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        startHour,
        startMinute,
      );

      final int endHour = _selectedEndHour!.floor();
      final int endMinute = ((_selectedEndHour! - endHour) * 60).round();
      final DateTime endTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        endHour,
        endMinute,
      );

      // Crear el DTO
      final dto = CreateCitaDoctorDto(
        patientId: _selectedPatientId!,
        // Convierte a UTC antes de enviar (toIso8601String lo hará)
        start: startTime.toUtc(), 
        end: endTime.toUtc(),
        reason: _reason,
        // nota: _notaController.text, // (Si tuvieras un campo de nota)
      );

      // Enviar a la API usando ref.read()
      await ref.read(apiServiceProvider).createCita(dto);

      setState(() => _isSaving = false);
      
      // Cerrar el modal y devolver 'true' para refrescar la agenda
      Navigator.pop(context, true); 

    } catch (e) {
      // Mostrar el error de la API (ej. "El doctor ya tiene una cita")
      setState(() {
        _isSaving = false;
        _timeError = e.toString().replaceFirst("Exception: ", "");
      });
    }
  }

  // --- Tus funciones de formato (sin cambios) ---
  List<double> _generateTimeSlots() {
    final List<double> hours = [];
    for (double h = 8.0; h <= 18.0; h += 0.5) { hours.add(h); }
    return hours;
  }
  String _formatHour(double hour) {
    final int h = hour.toInt();
    final int m = ((hour - h) * 60).toInt();
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}";
  }
  // (No se necesita _convertToHalfHourIndex ya que enviamos DateTime)

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final timeSlots = _generateTimeSlots();
    final startTimes = timeSlots.where((t) => t < 18.0).toList();
    List<double> getEndTimes(double? startTime) {
      if (startTime == null) return [];
      return timeSlots
          .where((t) => t >= startTime + 0.5 && t <= startTime + 1.0)
          .toList();
    }
    final endTimes = getEndTimes(_selectedStartHour);

    return Padding(
      // Padding para el teclado
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Nueva Cita",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 16),

            // --- 12. Dropdown de Paciente (Actualizado) ---
            if (_isLoadingPatients)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(strokeWidth: 2),
                    SizedBox(width: 16),
                    Text("Cargando pacientes..."),
                  ],
                ),
              )
            else if (_patientLoadError != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Error al cargar pacientes:\n$_patientLoadError",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.error),
                ),
              )
            else
              DropdownButtonFormField<String>( // <-- Tipo String
                decoration: const InputDecoration(labelText: "Paciente"),
                value: _selectedPatientId,
                items: _patients.map((patient) {
                  return DropdownMenuItem<String>(
                    value: patient.id, // <-- Valor es el UUID
                    child: Text(patient.fullName), // Nombre desde API
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedPatientId = val),
              ),

            // Razón o descripción
            TextFormField(
              decoration: const InputDecoration(labelText: "Razón / Descripción"),
              onChanged: (val) => _reason = val,
            ),
            const SizedBox(height: 16),

            // Fecha (sin cambios)
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? "Seleccionar día"
                        : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  child: const Text("Elegir día"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Hora de inicio (sin cambios)
            DropdownButtonFormField<double>(
              decoration: const InputDecoration(labelText: "Hora inicio"),
              value: _selectedStartHour,
              items: startTimes.map((hour) {
                return DropdownMenuItem<double>(
                  value: hour,
                  child: Text(_formatHour(hour)),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedStartHour = val;
                  if (_selectedEndHour != null &&
                      (_selectedEndHour! - _selectedStartHour! < 0.5 ||
                          _selectedEndHour! - _selectedStartHour! > 1.0)) {
                    _selectedEndHour = null;
                  }
                });
              },
            ),
            const SizedBox(height: 16),

            // Hora de fin (sin cambios)
            DropdownButtonFormField<double>(
              decoration: const InputDecoration(labelText: "Hora fin"),
              value: _selectedEndHour,
              items: endTimes.map((hour) {
                return DropdownMenuItem<double>(
                  value: hour,
                  child: Text(_formatHour(hour)),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedEndHour = val),
            ),

            // Mensaje de error de validación
            if (_timeError != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  _timeError!,
                  style: TextStyle(color: colors.error, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 24),

            // Botón Guardar
            if (_isSaving)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                onPressed: _saveAppointment,
                icon: const Icon(Icons.check),
                label: const Text("Guardar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  minimumSize: const Size(double.infinity, 44),
                ),
              ),
          ],
        ),
      ),
    );
  }
}