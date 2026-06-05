import 'package:flutter/foundation.dart';

import '../../../../core/shared/mixins/loading_state_mixin.dart';
import '../../domain/entities/catalog_item.dart';
import '../../domain/entities/trick.dart';
import '../../domain/usecases/create_trick_usecase.dart';
import '../../domain/usecases/get_catalogs_usecase.dart';
import '../../domain/usecases/update_trick_usecase.dart';

/// ViewModel del formulario de truco (CREAR o EDITAR).
class TrickFormViewModel extends ChangeNotifier with LoadingStateMixin {
  final CreateTrickUseCase _createTrickUseCase;
  final UpdateTrickUseCase _updateTrickUseCase;
  final GetCatalogsUseCase _getCatalogsUseCase;

  /// Si es null, estamos creando. Si trae un truco, estamos editándolo.
  final Trick? editing;

  TrickFormViewModel({
    required CreateTrickUseCase createTrickUseCase,
    required UpdateTrickUseCase updateTrickUseCase,
    required GetCatalogsUseCase getCatalogsUseCase,
    this.editing,
  })  : _createTrickUseCase = createTrickUseCase,
        _updateTrickUseCase = updateTrickUseCase,
        _getCatalogsUseCase = getCatalogsUseCase {
    if (editing != null) {
      selectedCategoryId = editing!.idCategory;
      selectedDifficultyId = editing!.idDifficulty;
      selectedLevelId = editing!.idLevelTrick;
    }
  }

  List<CatalogItem> categories = [];
  List<CatalogItem> difficulties = [];
  List<CatalogItem> levels = [];

  int? selectedCategoryId;
  int? selectedDifficultyId;
  int? selectedLevelId;

  bool get isEditing => editing != null;

  Future<void> loadCatalogs() async {
    final result = await guard(_getCatalogsUseCase.call);
    if (result == null) return;
    categories = result.categories;
    difficulties = result.difficulties;
    levels = result.levels;
    if (editing == null) {
      selectedCategoryId ??=
      categories.isNotEmpty ? categories.first.id : null;
      selectedDifficultyId ??=
      difficulties.isNotEmpty ? difficulties.first.id : null;
      selectedLevelId ??= levels.isNotEmpty ? levels.first.id : null;
    }
    notifyListeners();
  }

  void setCategory(int? id) {
    selectedCategoryId = id;
    notifyListeners();
  }

  void setDifficulty(int? id) {
    selectedDifficultyId = id;
    notifyListeners();
  }

  void setLevel(int? id) {
    selectedLevelId = id;
    notifyListeners();
  }

  /// Crea o actualiza según corresponda. Devuelve true si tuvo éxito.
  Future<bool> submit({
    required String title,
    required String description,
    required int idUser,
  }) async {
    // Validación local previa al guard (no es un error de red).
    if (selectedCategoryId == null ||
        selectedDifficultyId == null ||
        selectedLevelId == null) {
      setError('Selecciona categoría, dificultad y nivel.');
      return false;
    }

    final ok = await guard(() async {
      final trick = Trick(
        id: editing?.id ?? 0,
        title: title,
        description: description,
        idCategory: selectedCategoryId!,
        idDifficulty: selectedDifficultyId!,
        idLevelTrick: selectedLevelId!,
        idUser: idUser,
      );
      if (isEditing) {
        await _updateTrickUseCase(trick);
      } else {
        await _createTrickUseCase(trick);
      }
      return true;
    });
    return ok ?? false;
  }
}