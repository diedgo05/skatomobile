import 'package:flutter/foundation.dart';

import '../../../../core/shared/mixins/loading_state_mixin.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_session_viewmodel.dart';

class LoginViewModel extends ChangeNotifier with LoadingStateMixin {
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

  /// Devuelve true si login + obtener usuario fue exitoso.
  Future<bool> submit({required String email, required String password}) async {
    final ok = await guard(() async {
      await _loginUseCase(email: email, password: password);
      final user = await _getCurrentUserUseCase();
      _authSession.setUser(user);
      return true;
    });
    return ok ?? false;
  }
}