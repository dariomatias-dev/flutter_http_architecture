import 'package:flutter/material.dart';

import 'package:flutter_http_architecture/src/core/http/dio_http_client.dart';
import 'package:flutter_http_architecture/src/core/http/network_config.dart';

class HttpBinRepository {
  final _httpClient = DioHttpClient(
    config: NetworkConfig(baseUrl: 'https://httpbin.org'),
  );

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = HttpBinRepository();

  String _selectedMethod = 'GET';
  int _selectedStatus = 200;
  String _result = '';
  bool _isLoading = false;

  final _methods = <String>['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'];
  final _statusCodes = <int>[
    200,
    201,
    202,
    204,
    301,
    400,
    401,
    403,
    404,
    405,
    409,
    422,
    500,
    502,
    503,
    504,
  ];

  Future<void> _execute() async {
    setState(() => _isLoading = true);

    final path = '/status/$_selectedStatus';
    final code = await _repository.request(path, method: _selectedMethod);

    setState(() {
      _result = 'Path: $path\nMethod: $_selectedMethod\nCode: $code';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'HTTP RUNNER',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Configuration',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24.0),
            DropdownButtonFormField<String>(
              initialValue: _selectedMethod,
              decoration: InputDecoration(
                labelText: 'METHOD',
                labelStyle: const TextStyle(fontSize: 10.0, letterSpacing: 1.0),
                filled: true,
                fillColor: Colors.grey[100.0.toInt()],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: _methods.map((method) {
                return DropdownMenuItem(value: method, child: Text(method));
              }).toList(),
              onChanged: _isLoading
                  ? null
                  : (value) => setState(() => _selectedMethod = value!),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<int>(
              initialValue: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'STATUS CODE',
                labelStyle: const TextStyle(fontSize: 10.0, letterSpacing: 1.0),
                filled: true,
                fillColor: Colors.grey[100.0.toInt()],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: _statusCodes.map((statusCode) {
                return DropdownMenuItem(
                  value: statusCode,
                  child: Text(statusCode.toString()),
                );
              }).toList(),
              onChanged: _isLoading
                  ? null
                  : (value) => setState(() => _selectedStatus = value!),
            ),
            const SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              height: 54.0,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _execute,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'RUN REQUEST',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
              ),
            ),
            if (_result.isNotEmpty) ...<Widget>[
              const SizedBox(height: 48.0),
              const Text(
                'RESPONSE',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50.0.toInt()]?.withAlpha(127),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  _result,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13.0,
                    fontFamily: 'monospace',
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
