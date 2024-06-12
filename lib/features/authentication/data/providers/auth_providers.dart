// data/providers/auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landing_page/features/authentication/data/repositories/auth_repository.dart';
import 'package:landing_page/features/authentication/domain/repositories/auth_repository_interface.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});
