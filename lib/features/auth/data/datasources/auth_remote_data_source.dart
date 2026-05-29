import '../../../../core/config/api_config.dart';
import '../../../../core/http/http_client.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final HttpClient httpClient;
  AuthRemoteDataSource(this.httpClient);

  /// POST /users/login -> { message, token }
  Future<String> login({required String email, required String password}) async {
    final res = await httpClient.post(
      ApiConfig.login,
      body: {'email': email, 'password': password},
    );
    if (res is Map && res['token'] != null) return res['token'].toString();
    throw Exception('Respuesta de login inválida');
  }

  /// POST /users/add
  /// joinDate la genera el cliente (la API lo requiere NOT NULL).
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required int idLevelUser,
  }) async {
    await httpClient.post(ApiConfig.register, body: {
      'username': username,
      'email': email,
      'password': password,
      'joinDate': DateTime.now().toUtc().toIso8601String(),
      'idLevelUser': idLevelUser,
    });
  }

  /// GET /users/me  (requiere Bearer token)
  Future<UserModel> getMe() async {
    final res = await httpClient.get(ApiConfig.me, authenticated: true);
    // La API podría devolver el usuario directo o envuelto en {user: {...}}; manejamos ambos.
    final map = (res is Map && res['user'] is Map) ? res['user'] : res;
    return UserModel.fromJson(Map<String, dynamic>.from(map as Map));
  }
}