import 'package:flutter/foundation.dart';

import '../../../../core/shared/mixins/loading_state_mixin.dart';
import '../../domain/usecases/register_usecase.dart';

class RegisterViewModel extends ChangeNotifier with LoadingStateMixin {
  final RegisterUseCase _registerUseCase;
  RegisterViewModel(this._registerUseCase);

  bool _success = false;
  bool get success => _success;

  Future<bool> submit({
    required String username,
    required String email,
    required String password,
    required int idLevelUser,
  }) async {
    _success = false;
    final ok = await guard(() async {
      await _registerUseCase(
        username: username,
        email: email,
        password: password,
        idLevelUser: idLevelUser,
      );
      _success = true;
      return true;
    });
    return ok ?? false;
  }
}