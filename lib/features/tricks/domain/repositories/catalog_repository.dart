import '../entities/catalog_item.dart';

abstract class CatalogRepository {
  Future<List<CatalogItem>> getCategories();
  Future<List<CatalogItem>> getDifficulties();
  Future<List<CatalogItem>> getLevelTricks();
}