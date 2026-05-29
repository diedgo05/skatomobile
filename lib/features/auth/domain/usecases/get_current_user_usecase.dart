import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// IMPORTANTE para el dominio de la app: después del login NO conocemos el
/// idUser (el endpoint /users/login solo devuelve el token). Sin idUser no
/// podemos crear trucos. Por eso, justo tras el login, llamamos a este caso.
class GetCurrentUserUseCase {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  Future<User> call() => repository.getCurrentUser();
}