import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer_group.dart';
import 'package:proyecto_hidoc/common/shared_widgets/header_bar.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/component/patient_item_list.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/footer_doctor.dart';
import 'package:proyecto_hidoc/features/doctor/widgets/patients.dart';

class PacientesScreen extends StatefulWidget {
  static const String name = 'pacientes_screen';
  const PacientesScreen({super.key});

  @override
  State<PacientesScreen> createState() => _PacientesScreenState();
}

class _PacientesScreenState extends State<PacientesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  List<Map<String, String>> filteredPatients = Patients;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterPatients);
    _searchFocus.addListener(() {
      setState(() {});
    });
  }

  void _filterPatients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredPatients = Patients.where((patient) {
        final name = patient['name']!.toLowerCase();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar.brand(
        logoAsset: 'assets/brand/hidoc_logo.png',
        title: 'Dra. Elena Martínez',
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded,
                color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Text('EM'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Buscador
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
                fillColor: Theme.of( context).colorScheme.secondaryContainer,
              ),
            ),
          ),
          // Lista de pacientes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 10.0),
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = filteredPatients[index];
                return PatientListItem(
                  patientName: patient['name']!,
                  initials: patient['initials']!,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Abrir detalle de ${patient['name']}')),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: FooterGroup(buttons: doctorFooterButtons(context)),
    );
  }
}

