import 'package:flutter/foundation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/register_usecase.dart';

/// ViewModel del registro. Mismo patrón que LoginViewModel.
class RegisterViewModel extends ChangeNotifier {
  final RegisterUseCase _registerUseCase;
  RegisterViewModel(this._registerUseCase);

  bool _loading = false;
  String? _error;
  bool _success = false;

  bool get loading => _loading;
  String? get error => _error;
  bool get success => _success;

  Future<bool> submit({
    required String username,
    required String email,
    required String password,
    required int idLevelUser,
  }) async {
    _error = null;
    _success = false;
    _loading = true;
    notifyListeners();

    try {
      await _registerUseCase(
        username: username,
        email: email,
        password: password,
        idLevelUser: idLevelUser,
      );
      _success = true;
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