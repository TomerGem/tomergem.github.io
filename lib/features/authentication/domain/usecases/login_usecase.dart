// domain/usecases/login_usecase.dart
import 'package:landing_page/features/authentication/domain/repositories/auth_repository_interface.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<void> call(String email, String password) {
    return repository.login(email, password);
  }
}
