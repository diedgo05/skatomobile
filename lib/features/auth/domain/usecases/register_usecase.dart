import '../repositories/auth_repository.dart';

/// Caso de uso: registrar un usuario nuevo.
class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<void> call({
    required String username,
    required String email,
    required String password,
    required int idLevelUser,
  }) {
    return repository.register(
      username: username,
      email: email,
      password: password,
      idLevelUser: idLevelUser,
    );
  }
}