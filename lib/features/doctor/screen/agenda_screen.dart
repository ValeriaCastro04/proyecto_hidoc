import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/doctor.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/footer_doctor.dart';
import '../screen/new_appointment_screen.dart'; 

import '../../../main.dart';
import '../models/cita_doctor.dart';

class AgendaScreen extends ConsumerStatefulWidget {
  static const String name = 'agenda_screen';
  const AgendaScreen({super.key});

  @override
  ConsumerState<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends ConsumerState<AgendaScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final List<String> _monthNames = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'
  ];
  final ScrollController _scrollController = ScrollController();
  static const double _halfHourHeight = 90.0;

  // --- 6. Nuevos estados para manejar la API ---
  bool _isLoading = true;
  String? _error;
  // Esta lista almacena las citas PROCESADAS en el formato que tu UI espera
  List<Map<String, Object>> _processedAppointments = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 7. Cargar datos al iniciar usando 'ref'
      _fetchAppointments();
      _scrollToCurrentHour();
    });
  }

  /// 8. TRADUCTOR: Convierte CitaDoctor (API) a Map (UI)
  /// Esto es clave para que tu UI de "índices" funcione.
  List<Map<String, Object>> _processApiCitas(List<CitaDoctor> citasApi) {
    return citasApi.map((cita) {
      // Convierte las fechas UTC de la API a la hora local del dispositivo
      final localStart = cita.start.toLocal();
      final localEnd = cita.end.toLocal();

      // Convierte la hora local al índice de 30 minutos que tu UI necesita
      final startIndex = (localStart.hour * 2) + (localStart.minute >= 30 ? 1 : 0);
      // El índice final es el inicio del slot, por eso no sumamos 1
      final endIndex = (localEnd.hour * 2) + (localEnd.minute > 0 ? 1 : 0);

      return {
        "patientName": cita.patient?.fullName ?? 'Paciente', 
        "reason": cita.reason,
        "timeStart": startIndex,
        "timeEnd": endIndex, // Ej: 10:00 a 10:30 es timeStart: 20, timeEnd: 21
        "color": Colors.blue.shade700, // Puedes cambiar esto
      };
    }).toList();
  }

  /// 9. Carga las citas desde la API
  Future<void> _fetchAppointments() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _processedAppointments = []; // Limpiar datos antiguos
    });

    try {
      // Usa ref.read() para obtener el servicio
      final apiService = ref.read(apiServiceProvider);
      final citasDelDia = await apiService.getCitasByDay(_selectedDay);
      
      final processedData = _processApiCitas(citasDelDia);

      setState(() {
        _processedAppointments = processedData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentHour();
    });
  }

  /// Cambiar de día (ahora recarga los datos)
  void _changeDay(int offset) {
    setState(() {
      _focusedDay = _focusedDay.add(Duration(days: offset));
      _selectedDay = _focusedDay;
    });
    _fetchAppointments(); // <-- RECARGA DATOS
  }

  /// Ir al día de hoy (ahora recarga los datos)
  void _goToToday() {
    setState(() {
      _focusedDay = DateTime.now();
      _selectedDay = DateTime.now();
    });
    _fetchAppointments(); // <-- RECARGA DATOS
  }

  /// 10. Abre el formulario para crear una nueva cita
  void _showNewAppointmentForm() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true, // Para que el teclado no tape el modal
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: NewAppointmentForm(initialDay: _selectedDay),
      ),
    );

    // Si el formulario devolvió 'true' (guardó exitosamente)
    if (result == true) {
      _fetchAppointments(); // Recargar la agenda
    }
  }

  // --- Tus funciones de formato (sin cambios) ---
  String _formatSelectedDay() {
    final day = _selectedDay.day;
    final month = _monthNames[_selectedDay.month];
    final year = _selectedDay.year;
    return '$day $month $year';
  }
  String _formatIndexToTime(int index) {
    final hour = index ~/ 2;
    final minute = (index % 2) * 30;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
  void _scrollToCurrentHour() {
     if (_selectedDay.day == DateTime.now().day &&
        _selectedDay.month == DateTime.now().month &&
        _selectedDay.year == DateTime.now().year) {
      final now = DateTime.now();
      final currentHalfHourIndex = (now.hour * 2) + (now.minute >= 30 ? 1 : 0);
      // Espera a que el scroll controller esté listo
      if (_scrollController.hasClients) {
         final offset = (currentHalfHourIndex - 3).clamp(0, 47) * _halfHourHeight;
        _scrollController.jumpTo(
          offset.clamp(0.0, _scrollController.position.maxScrollExtent),
        );
      }
    } else {
      if (_scrollController.hasClients) {
         _scrollController.jumpTo(0);
      }
    }
  }

  /// 11. Widget para el cuerpo (Loading/Error/Data)
  Widget _buildAgendaBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error al cargar citas:\n$_error',
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.error)
          ),
        ),
      );
    }
    
    // Tu ListView original, pero usando _processedAppointments
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: 48, 
      itemBuilder: (context, index) {
        final colors = Theme.of(context).colorScheme;
        
        // Buscar cita que contenga este intervalo
        final appointment = _processedAppointments.firstWhere(
          (a) => index >= (a['timeStart'] as int) && index < (a['timeEnd'] as int),
          orElse: () => <String, Object>{},
        );

        if (appointment.isNotEmpty) {
          // --- 1. Extraer y castear los valores ---
          final int timeStart = appointment['timeStart'] as int;
          final int timeEnd = appointment['timeEnd'] as int;
          final String patientName = appointment['patientName'] as String;
          final String reason = appointment['reason'] as String;
          final Color color = appointment['color'] as Color;

          // Si este índice es el inicio de una cita
          if (index == timeStart) {
            // --- 2. Usar las variables ya casteadas ---
            final durationInHalfHours = timeEnd - timeStart;

            final appointmentHeight = _halfHourHeight * durationInHalfHours;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(12),
              height: appointmentHeight,
              decoration: BoxDecoration(
                color: color.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patientName,
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    reason,
                    maxLines: durationInHalfHours > 1 ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.onPrimary.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${_formatIndexToTime(timeStart)} - ${_formatIndexToTime(timeEnd)}',
                    style: TextStyle(
                      color: colors.onPrimary.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        } else {
          // Espacio vacío de media hora
          final isHourMark = index % 2 == 0;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 0),
            height: _halfHourHeight,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colors.onBackground.withOpacity(0.1),
                ),
              ),
            ),
            child: Text(
              _formatIndexToTime(index),
              style: TextStyle(
                color: colors.onBackground
                    .withOpacity(isHourMark ? 0.8 : 0.4),
                fontSize: 12,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    // Ya no usamos mocks
    // final appointments = _getAppointmentsForDay(_selectedDay);

    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        actions: [
          ThemeToggleButton(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_rounded,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            child: Text(
              'Dr.'
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),

      body: Column(
        children: [
          Container(
            color: colors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () => _changeDay(-1),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: _goToToday,
                      child: const Text(
                        "HOY",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatSelectedDay(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: () => _changeDay(1),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          /// 13. Usar el nuevo body
          Expanded(
            child: _buildAgendaBody(),
          ),
        ],
      ),

      /// 14. Botón para AÑADIR CITA
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewAppointmentForm,
        tooltip: 'Nueva Cita',
        child: const Icon(Icons.add),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),

      bottomNavigationBar: FooterGroup(
        buttons: doctorFooterButtons(context),
      ),
    );
  }
}