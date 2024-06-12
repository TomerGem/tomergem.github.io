// presentation/providers/auth_state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landing_page/features/authentication/data/providers/auth_providers.dart';
import 'package:landing_page/features/authentication/domain/repositories/auth_repository_interface.dart';

final emailProvider = StateProvider<String>((ref) => '');
final passwordProvider = StateProvider<String>((ref) => '');

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(authRepository);
});

class AuthStateNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;

  AuthStateNotifier(this._authRepository) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.login(email, password);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
