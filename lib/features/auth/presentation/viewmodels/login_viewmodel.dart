import 'package:flutter/foundation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_session_viewmodel.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final AuthSession _authSession;

  LoginViewModel({
    required LoginUseCase loginUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required AuthSession authSession,
  })  : _loginUseCase = loginUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _authSession = authSession;

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  /// Devuelve true si el login + obtención del usuario fue exitoso.
  /// La View navega a Tricks cuando esto devuelve true.
  Future<bool> submit({required String email, required String password}) async {
    _error = null;
    _loading = true;
    notifyListeners();

    try {
      // 1) login -> guarda el token internamente
      await _loginUseCase(email: email, password: password);
      // 2) /users/me -> guarda el usuario en la sesión global
      final user = await _getCurrentUserUseCase();
      _authSession.setUser(user);
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      _error = 'Error inesperado. Revisa tu conexión.';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}