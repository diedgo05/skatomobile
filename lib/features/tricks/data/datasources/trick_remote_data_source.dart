import '../../../../core/config/api_config.dart';
import '../../../../core/http/http_client.dart';
import '../models/trick_model.dart';

class TrickRemoteDataSource {
  final HttpClient httpClient;
  TrickRemoteDataSource(this.httpClient);

  Future<List<TrickModel>> getAll() async {
    final res = await httpClient.get(ApiConfig.tricks);
    return _parseList(res);
  }

  Future<List<TrickModel>> getByUser(int idUser) async {
    final res = await httpClient.get(ApiConfig.tricksByUser(idUser));
    return _parseList(res);
  }

  Future<void> create(TrickModel trick) async {
    await httpClient.post(ApiConfig.tricksAdd, body: trick.toJson());
  }

  Future<void> update(TrickModel trick) async {
    await httpClient.put(ApiConfig.tricksUpdate(trick.id), body: trick.toJson());
  }

  Future<void> delete(int id) async {
    await httpClient.delete(ApiConfig.tricksDelete(id));
  }

  List<TrickModel> _parseList(dynamic res) {
    final list = (res is Map && res['tricks'] is List) ? res['tricks'] : res;
    if (list is! List) return [];
    return list
        .whereType<Map>()
        .map((e) => TrickModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}