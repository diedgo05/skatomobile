import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<String> login({required String email, required String password}) async {
    final token =
    await remoteDataSource.login(email: email, password: password);
    await tokenStorage.saveToken(token); // efecto colateral: persistimos el JWT
    return token;
  }

  @override
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required int idLevelUser,
  }) {
    return remoteDataSource.register(
      username: username,
      email: email,
      password: password,
      idLevelUser: idLevelUser,
    );
  }

  @override
  Future<User> getCurrentUser() => remoteDataSource.getMe();

  @override
  Future<void> logout() => tokenStorage.clear();
}