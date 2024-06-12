// data/repositories/auth_repository.dart
import 'package:landing_page/features/authentication/domain/repositories/auth_repository_interface.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> login(String username, String password) async {
    // Implement your login logic here (e.g., network request)
  }
}
