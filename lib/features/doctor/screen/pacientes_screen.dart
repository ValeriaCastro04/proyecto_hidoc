import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Importar Riverpod
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/patient_item_list.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/footer_doctor.dart';
// import 'package:proyecto_hidoc/features/doctor/widgets/list/patients.dart'; // 2. Ya no usamos el mock
import 'patient_history_screen.dart';
import 'package:proyecto_hidoc/common/shared_widgets/theme_toggle_button.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/list/doctor.dart';

import '../../../main.dart'; // 3. Importar para el apiServiceProvider
import '../models/patient.dart'; // 4. Importar el modelo Patient

// 5. Convertir a ConsumerStatefulWidget
class PacientesScreen extends ConsumerStatefulWidget {
  static const String name = 'pacientes_screen';
  const PacientesScreen({super.key});

  @override
  ConsumerState<PacientesScreen> createState() => _PacientesScreenState();
}

// 6. Convertir a ConsumerState
class _PacientesScreenState extends ConsumerState<PacientesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  // 7. Nuevos estados para manejar la API
  bool _isLoading = true;
  String? _error;
  List<Patient> _allPatients = [];     // Lista maestra de la API
  List<Patient> _filteredPatients = []; // Lista para la UI

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterPatients);
    _searchFocus.addListener(() {
      setState(() {});
    });
    // 8. Cargar pacientes al iniciar
    _fetchPatients();
  }

  /// 9. Carga los pacientes desde la API
  Future<void> _fetchPatients() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Usamos ref (disponible en ConsumerState) para leer el provider
      final patientsFromApi = await ref.read(apiServiceProvider).getPatients();
      
      setState(() {
        _allPatients = patientsFromApi;
        _filteredPatients = patientsFromApi; // Al inicio, la lista filtrada es igual a la total
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString().replaceFirst("Exception: ", "");
      });
    }
  }

  /// 10. Lógica de filtro actualizada
  void _filterPatients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      // Filtra la lista _allPatients (de la API)
      _filteredPatients = _allPatients.where((patient) {
        // Usa la propiedad del modelo Patient
        final name = patient.fullName.toLowerCase(); 
        return name.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  /// 11. Widget helper para construir la lista (con loading/error)
  Widget _buildPatientList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error al cargar pacientes:\n$_error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
      );
    }

    if (_filteredPatients.isEmpty) {
      return Center(
        child: Text(_searchController.text.isEmpty
            ? 'No hay pacientes registrados.'
            : 'No se encontraron pacientes.'),
      );
    }

    // 12. ListView.builder actualizado
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 10.0),
      itemCount: _filteredPatients.length,
      itemBuilder: (context, index) {
        // Ahora 'patient' es un objeto de tipo Patient
        final patient = _filteredPatients[index]; 

        // Derivamos los iniciales del nombre
        final initials = patient.fullName.split(' ')
            .map((e) => e.isNotEmpty ? e[0] : '')
            .take(2)
            .join()
            .toUpperCase();
            
        return PatientListItem(
          patientName: patient.fullName, // Usamos la propiedad del modelo
          onTap: () {
            
            // ⚠️ NOTA IMPORTANTE:
            // Tu API (getPatients) solo devuelve id, fullName, email, phone.
            // La pantalla PatientHistoryScreen espera 'numero_DUI' e 'history',
            // que no tenemos. Los pasaremos como vacíos por ahora.
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PatientHistoryScreen(
                  name: patient.fullName,
                  initials: initials,
                  // Asumimos que tu modelo Patient tiene 'email' y 'phone'
                  // Si no los tiene, el .fromJson debe ser actualizado
                  correo: patient.email ?? 'No disponible', 
                  telefono: patient.phone ?? 'No disponible',
                  numero_DUI: 'No disponible',
                  history: [],
                ),
              ),
            );
          },
        );
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
            icon: Icon(Icons.notifications_none_rounded,
                color: Theme.of(context).colorScheme.onSurface),
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
          // Buscador (sin cambios)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              focusNode: _searchFocus,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar paciente',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondaryContainer,
              ),
            ),
          ),
          // 13. Lista de pacientes (ahora usa el helper)
          Expanded(
            child: _buildPatientList(),
          ),
        ],
      ),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons(context)),
    );
  }
}