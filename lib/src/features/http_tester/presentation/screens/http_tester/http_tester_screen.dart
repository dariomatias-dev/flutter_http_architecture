import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/features/http_tester/di/http_tester_providers.dart';

final methods = <String>['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'];
final retryOptions = <int>[0, 1, 2, 3, 4, 5];
final statusCodes = <int>[200, 201, 401, 404, 429, 500, 503, 504];

class HttpTesterScreen extends ConsumerWidget {
  const HttpTesterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(httpTesterNotifierProvider);
    final notifier = ref.read(httpTesterNotifierProvider.notifier);

    final stateData = asyncState.requireValue;
    final isLoading = asyncState.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text(
          'HTTP ARCHITECTURE',
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _sectionTitle('REQUEST CONFIGURATION'),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: stateData.method,
                      decoration: _inputStyle('METHOD'),
                      items: methods.map<DropdownMenuItem<String>>((String m) {
                        return DropdownMenuItem<String>(
                          value: m,
                          child: Text(m),
                        );
                      }).toList(),
                      onChanged: isLoading
                          ? null
                          : (String? v) => notifier.updateMethod(v!),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: stateData.statusCode,
                      decoration: _inputStyle('STATUS'),
                      items: statusCodes.map<DropdownMenuItem<int>>((int s) {
                        return DropdownMenuItem<int>(
                          value: s,
                          child: Text(s.toString()),
                        );
                      }).toList(),
                      onChanged: isLoading
                          ? null
                          : (int? v) => notifier.updateStatus(v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                initialValue: stateData.maxRetries,
                decoration: _inputStyle('MAX RETRIES'),
                items: retryOptions.map<DropdownMenuItem<int>>((int r) {
                  return DropdownMenuItem<int>(
                    value: r,
                    child: Text('$r Attempts'),
                  );
                }).toList(),
                onChanged: isLoading
                    ? null
                    : (int? v) => notifier.updateRetryCount(v!),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Delay logic: 2s * (attempt + 1). Example: 2s, 4s, 6s...',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 54.0,
                child: ElevatedButton(
                  onPressed: isLoading ? null : notifier.runRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'EXECUTE REQUEST',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 28.0),
                child: Divider(),
              ),
              if (isLoading)
                Center(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 40.0),
                      const CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2.0,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'WAITING FOR RESPONSE...',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              else if (stateData.result.isNotEmpty) ...<Widget>[
                _sectionTitle('METRICS & PERFORMANCE'),
                const SizedBox(height: 12.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _metricTile(
                        'Latency',
                        stateData.duration,
                        Icons.speed,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: _metricTile(
                        'Retry Count',
                        '${stateData.actualRetries}',
                        Icons.refresh,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                _sectionTitle('RESPONSE BODY'),
                const SizedBox(height: 12.0),
                _codeBlock(stateData.result, const Color(0xFF1A1A1A)),
                const SizedBox(height: 24.0),
                _sectionTitle('HEADERS'),
                const SizedBox(height: 12.0),
                _codeBlock(stateData.headers, const Color(0xFF2C2C2C)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 11.0,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _metricTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 16.0, color: Colors.black54),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.0,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _codeBlock(String content, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        content,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.0,
          fontFamily: 'monospace',
          height: 1.5,
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
