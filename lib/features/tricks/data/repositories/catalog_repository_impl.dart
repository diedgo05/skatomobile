import '../../domain/entities/catalog_item.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_remote_data_source.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource remoteDataSource;
  CatalogRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CatalogItem>> getCategories() =>
      remoteDataSource.getCategories();

  @override
  Future<List<CatalogItem>> getDifficulties() =>
      remoteDataSource.getDifficulties();

  @override
  Future<List<CatalogItem>> getLevelTricks() =>
      remoteDataSource.getLevelTricks();
}