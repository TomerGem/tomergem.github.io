// domain/repositories/auth_repository_interface.dart
abstract class AuthRepository {
  Future<void> login(String username, String password);
}
