import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../error/failure.dart';
import '../storage/token_storage.dart';

class HttpClient {
  final http.Client _client;
  final TokenStorage _tokenStorage;

  HttpClient({http.Client? client, required TokenStorage tokenStorage})
      : _client = client ?? http.Client(),
        _tokenStorage = tokenStorage;

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<Map<String, String>> _headers({bool authenticated = false}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (authenticated) {
      final token = await _tokenStorage.getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<dynamic> get(String path, {bool authenticated = false}) async {
    final res = await _client.get(_uri(path),
        headers: await _headers(authenticated: authenticated));
    return _process(res);
  }

  Future<dynamic> post(String path,
      {Map<String, dynamic>? body, bool authenticated = false}) async {
    final res = await _client.post(_uri(path),
        headers: await _headers(authenticated: authenticated),
        body: jsonEncode(body ?? {}));
    return _process(res);
  }

  Future<dynamic> put(String path,
      {Map<String, dynamic>? body, bool authenticated = false}) async {
    final res = await _client.put(_uri(path),
        headers: await _headers(authenticated: authenticated),
        body: jsonEncode(body ?? {}));
    return _process(res);
  }

  Future<dynamic> delete(String path, {bool authenticated = false}) async {
    final res = await _client.delete(_uri(path),
        headers: await _headers(authenticated: authenticated));
    return _process(res);
  }

  /// Valida el código de estado y devuelve el JSON ya decodificado.
  /// Si la respuesta viene vacía (ej. DELETE -> 204) devuelve null.
  dynamic _process(http.Response res) {
    final ok = res.statusCode >= 200 && res.statusCode < 300;

    dynamic decoded;
    if (res.body.isNotEmpty) {
      try {
        decoded = jsonDecode(res.body);
      } catch (_) {
        decoded = res.body; // no era JSON; lo dejamos como texto
      }
    }

    if (ok) return decoded;

    // La API responde errores como {message: "..."} o {error: "..."}
    final msg = (decoded is Map && (decoded['message'] ?? decoded['error']) != null)
        ? (decoded['message'] ?? decoded['error']).toString()
        : 'Ocurrió un error (código ${res.statusCode})';
    throw ApiException(msg, statusCode: res.statusCode);
  }
}