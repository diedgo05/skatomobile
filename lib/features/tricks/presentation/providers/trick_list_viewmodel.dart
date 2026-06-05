import 'package:flutter/foundation.dart';

import '../../../../core/shared/mixins/loading_state_mixin.dart';
import '../../domain/entities/trick.dart';
import '../../domain/usecases/delete_trick_usecase.dart';
import '../../domain/usecases/get_tricks_usecase.dart';

class TrickListViewModel extends ChangeNotifier with LoadingStateMixin {
  final GetTricksUseCase _getTricksUseCase;
  final DeleteTrickUseCase _deleteTrickUseCase;

  TrickListViewModel({
    required GetTricksUseCase getTricksUseCase,
    required DeleteTrickUseCase deleteTrickUseCase,
  })  : _getTricksUseCase = getTricksUseCase,
        _deleteTrickUseCase = deleteTrickUseCase;

  List<Trick> _tricks = [];
  List<Trick> get tricks => _tricks;

  Future<void> load(int idUser) async {
    final result = await guard(() => _getTricksUseCase(idUser: idUser));
    if (result != null) {
      _tricks = result;
      notifyListeners();
    }
  }

  Future<bool> remove(int id, int idUser) async {
    final ok = await guard(() async {
      await _deleteTrickUseCase(id);
      return true;
    });
    if (ok == true) {
      await load(idUser);
      return true;
    }
    return false;
  }
}