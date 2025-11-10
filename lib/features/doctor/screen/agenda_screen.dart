import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';
import 'package:proyecto_hidoc/features/doctor/model/cita_doctor.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/footer_doctor.dart';
import '../screen/new_appointment_screen.dart'; 
import '../../../main.dart';

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

  bool _isLoading = true;
  String? _error;
  // lista almacena las citas PROCESADAS en el formato que tu UI espera
  List<Map<String, Object>> _processedAppointments = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAppointments();
      _scrollToCurrentHour();
    });
  }

  /// convierte CitaDoctor (API) a Map (UI)
  List<Map<String, Object>> _processApiCitas(List<CitaDoctor> citasApi) {
    return citasApi.map((cita) {
      final localStart = cita.start.toLocal();
      final localEnd = cita.end.toLocal();

      final startIndex = (localStart.hour * 2) + (localStart.minute >= 30 ? 1 : 0);
      final endIndex = (localEnd.hour * 2) + (localEnd.minute > 0 ? 1 : 0);

      return {
        "patientName": cita.patient?.fullName ?? 'Paciente', 
        "reason": cita.reason,
        "timeStart": startIndex,
        "timeEnd": endIndex,
        "color": Colors.blue.shade700, 
      };
    }).toList();
  }

  /// carga las citas desde la API
  Future<void> _fetchAppointments() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _processedAppointments = []; 
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
    _fetchAppointments();
  }

  /// Ir al día de hoy (ahora recarga los datos)
  void _goToToday() {
    setState(() {
      _focusedDay = DateTime.now();
      _selectedDay = DateTime.now();
    });
    _fetchAppointments(); 
  }

  ///formulario para crear una nueva cita
  void _showNewAppointmentForm() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
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

  // funciones de formato
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

  /// widget para el cuerpo
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
          final int timeStart = appointment['timeStart'] as int;
          final int timeEnd = appointment['timeEnd'] as int;
          final String patientName = appointment['patientName'] as String;
          final String reason = appointment['reason'] as String;
          final Color color = appointment['color'] as Color;

          if (index == timeStart) {
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
          
          /// el nuevo body
          Expanded(
            child: _buildAgendaBody(),
          ),
        ],
      ),

      /// botón para AÑADIR CITA
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