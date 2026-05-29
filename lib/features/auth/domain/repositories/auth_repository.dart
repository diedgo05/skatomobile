import '../entities/user.dart';

abstract class AuthRepository {
  /// Hace login y devuelve el JWT. Lanza ApiException si falla.
  Future<String> login({required String email, required String password});

  /// Registra un usuario nuevo.
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required int idLevelUser,
  });

  /// Devuelve el usuario actualmente autenticado (lee token internamente).
  Future<User> getCurrentUser();

  /// Borra el token local (logout).
  Future<void> logout();
}