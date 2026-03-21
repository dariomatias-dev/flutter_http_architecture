import 'package:flutter_http_architecture/src/core/http/http_client.dart';

class HttpBinRepository {
  late final HttpClient _httpClient;

  HttpBinRepository({required HttpClient httpClient})
    : _httpClient = httpClient;

  Future<int> request(String path, {String method = 'GET'}) async {
    final response = await (switch (method) {
      'POST' => _httpClient.post<Map<String, dynamic>>(
        path,
        data: <String, dynamic>{},
      ),
      'PUT' => _httpClient.put<Map<String, dynamic>>(
        path,
        data: <String, dynamic>{},
      ),
      'PATCH' => _httpClient.patch<Map<String, dynamic>>(
        path,
        data: <String, dynamic>{},
      ),
      'DELETE' => _httpClient.delete<Map<String, dynamic>>(path),
      _ => _httpClient.get<Map<String, dynamic>>(path),
    });

    return response.statusCode ?? 0.0.toInt();
  }
}
