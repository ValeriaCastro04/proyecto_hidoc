import '../../core/token_storage.dart';
import 'auth_api.dart';

class AuthRepository {
  final AuthApi api;
  final TokenStorage storage;
  AuthRepository(this.api, this.storage);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = await api.login(email, password);
    await storage.save(
      access: data['access_token'],
      refresh: data['refresh_token'],
    );
    return data['user'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> currentUser() => api.me();

  Future<void> logout() async {
    await api.logout();
    await storage.clear();
  }
}