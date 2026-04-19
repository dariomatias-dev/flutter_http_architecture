import 'package:flutter_http_architecture/src/core/http/client/http_client.dart';
import 'package:flutter_http_architecture/src/core/http/options/http_request_options.dart';

abstract class IHttpBinRepository {
  Future<int> get(String path);

  Future<int> post(String path);

  Future<int> put(String path);

  Future<int> patch(String path);

  Future<int> delete(String path);

  Future<int> options(String path);
}

class HttpBinRepository implements IHttpBinRepository {
  final HttpClient _httpClient;

  HttpBinRepository({required HttpClient httpClient})
    : _httpClient = httpClient;

  @override
  Future<int> get(String path) async {
    final response = await _httpClient.get<Map<String, dynamic>>(path, options: HttpRequestOptions(maxRetries: 2));

    return response.statusCode ?? 0;
  }

  @override
  Future<int> post(String path) async {
    final response = await _httpClient.post<Map<String, dynamic>>(
      path,
      data: <String, dynamic>{},
    );

    return response.statusCode ?? 0;
  }

  @override
  Future<int> put(String path) async {
    final response = await _httpClient.put<Map<String, dynamic>>(
      path,
      data: <String, dynamic>{},
    );

    return response.statusCode ?? 0;
  }

  @override
  Future<int> patch(String path) async {
    final response = await _httpClient.patch<Map<String, dynamic>>(
      path,
      data: <String, dynamic>{},
    );

    return response.statusCode ?? 0;
  }

  @override
  Future<int> delete(String path) async {
    final response = await _httpClient.delete<Map<String, dynamic>>(path);

    return response.statusCode ?? 0;
  }

  @override
  Future<int> options(String path) async {
    final response = await _httpClient.options<Map<String, dynamic>>(path);

    return response.statusCode ?? 0;
  }
}
