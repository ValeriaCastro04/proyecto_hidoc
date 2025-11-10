import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Ajusta la ruta a tu ApiService

class DoctorProfileProvider extends ChangeNotifier {
  final ApiService _apiService;

  Map<String, dynamic>? _doctorProfile;
  Map<String, dynamic>? get doctorProfile => _doctorProfile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // El constructor recibe la instancia de ApiService
  DoctorProfileProvider(this._apiService) {
    // Inicia la carga del perfil en cuanto se crea el provider
    fetchDoctorProfile();
  }

  Future<void> fetchDoctorProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // Notifica a los widgets que la carga comenzó

    try {
      // ¡Importante! Llama al método desde la INSTANCIA _apiService
      _doctorProfile = await _apiService.getMyDoctorProfile();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifica que la carga terminó (con éxito o error)
    }
  }
}