import '../entities/catalog_item.dart';
import '../repositories/catalog_repository.dart';

/// Carga los 3 catálogos (categorías, dificultades, niveles) en paralelo.
class GetCatalogsUseCase {
  final CatalogRepository repository;
  GetCatalogsUseCase(this.repository);

  Future<({List<CatalogItem> categories, List<CatalogItem> difficulties, List<CatalogItem> levels})>
  call() async {
    final results = await Future.wait([
      repository.getCategories(),
      repository.getDifficulties(),
      repository.getLevelTricks(),
    ]);
    return (
    categories: results[0],
    difficulties: results[1],
    levels: results[2],
    );
  }
}