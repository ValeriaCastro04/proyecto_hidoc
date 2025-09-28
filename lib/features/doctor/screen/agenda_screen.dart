import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/appointments.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/footer_doctor.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';

class AgendaScreen extends StatefulWidget {
  static const String name = 'agenda_screen';
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final List<String> _monthNames = [
    '', // índice 0 vacío para que Enero = 1
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Cuando se abre la pantalla, enfocar la hora actual
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentHour();
    });
  }

  /// Obtiene las citas del día seleccionado
  List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
    return mockAppointmentsByDate.entries
        .firstWhere(
          (entry) =>
              entry.key.year == day.year &&
              entry.key.month == day.month &&
              entry.key.day == day.day,
          orElse: () => MapEntry(day, []),
        )
        .value;
  }

  /// Cambiar de día con las flechas
  void _changeDay(int offset) {
    setState(() {
      _focusedDay = _focusedDay.add(Duration(days: offset));
      _selectedDay = _focusedDay;
    });
    // Actualizar scroll al cambiar de día
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentHour();
    });
  }

  /// Ir al día de hoy
  void _goToToday() {
    setState(() {
      _focusedDay = DateTime.now();
      _selectedDay = DateTime.now();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentHour();
    });
  }

  /// Formatea la fecha como "27 Sept 2025"
  String _formatSelectedDay() {
    final day = _selectedDay.day;
    final month = _monthNames[_selectedDay.month];
    final year = _selectedDay.year;
    return '$day $month $year';
  }

  /// Desplaza la lista a la hora actual
  void _scrollToCurrentHour() {
    if (_selectedDay.day == DateTime.now().day &&
        _selectedDay.month == DateTime.now().month &&
        _selectedDay.year == DateTime.now().year) {
      final currentHour = DateTime.now().hour;
      // Cada item tiene altura 50 (horas vacías) o más si tiene cita
      // Aquí aproximamos: cada fila = 50
      final offset = currentHour * 50.0;
      _scrollController.jumpTo(offset);
    } else {
      // Si no es hoy, dejar al inicio
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final appointments = _getAppointmentsForDay(_selectedDay);

    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: 'Dra. Elena Martínez',
        actions: [
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
            child: const Text('EM'),
          ),
          const SizedBox(width: 16),
        ],
      ),

      /// Subheader para navegación de días
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
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatSelectedDay(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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

          /// Agenda
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: 24,
              itemBuilder: (context, index) {
                final appointment = appointments.firstWhere(
                  (a) => index >= a['timeStart'] && index < a['timeEnd'],
                  orElse: () => {},
                );

                if (appointment.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    height:
                        90.0 * (appointment['timeEnd'] - appointment['timeStart']),
                    decoration: BoxDecoration(
                      color: (appointment['color'] as Color).withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment['patientName'],
                          style: TextStyle(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          appointment['reason'],
                          style: TextStyle(
                            color: colors.onPrimary.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${appointment['timeStart'].toString().padLeft(2, '0')}:00 - '
                          '${appointment['timeEnd'].toString().padLeft(2, '0')}:00',
                          style: TextStyle(
                            color: colors.onPrimary.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    height: 50,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: colors.onBackground.withOpacity(0.1)),
                      ),
                    ),
                    child: Text(
                      '${index.toString().padLeft(2, '0')}:00',
                      style: TextStyle(
                        color: colors.onBackground.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons(context)),
    );
  }
}
