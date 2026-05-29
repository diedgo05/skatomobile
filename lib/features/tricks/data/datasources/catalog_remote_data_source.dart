import '../../../../core/config/api_config.dart';
import '../../../../core/http/http_client.dart';
import '../models/catalog_item_model.dart';

class CatalogRemoteDataSource {
  final HttpClient httpClient;
  CatalogRemoteDataSource(this.httpClient);

  Future<List<CatalogItemModel>> getCategories() =>
      _fetchList(ApiConfig.categories);
  Future<List<CatalogItemModel>> getDifficulties() =>
      _fetchList(ApiConfig.difficulties);
  Future<List<CatalogItemModel>> getLevelTricks() =>
      _fetchList(ApiConfig.levelTricks);

  Future<List<CatalogItemModel>> _fetchList(String path) async {
    final res = await httpClient.get(path);
    if (res is! List) return [];
    return res
        .whereType<Map>()
        .map((e) => CatalogItemModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}