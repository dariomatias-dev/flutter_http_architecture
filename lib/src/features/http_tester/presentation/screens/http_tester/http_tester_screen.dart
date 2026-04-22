import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/core/di/theme_notifier_provider.dart';

import 'package:flutter_http_architecture/src/features/http_tester/di/http_tester_providers.dart';

import 'package:flutter_http_architecture/src/shared/widgets/dropdown_widget.dart';

final methods = <String>['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'];
final retryOptions = <int>[0, 1, 2, 3, 4, 5];
final statusCodes = <int>[200, 201, 401, 404, 429, 500, 503, 504];

class HttpTesterScreen extends ConsumerWidget {
  const HttpTesterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final asyncState = ref.watch(httpTesterNotifierProvider);
    final notifier = ref.read(httpTesterNotifierProvider.notifier);

    final stateData = asyncState.requireValue;
    final isLoading = asyncState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HTTP ARCHITECTURE',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: ref.read(themeNotifierProvider.notifier).toggleTheme,
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _sectionTitle('REQUEST CONFIGURATION', theme),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownWidget<String>(
                      label: 'METHOD',
                      initialValue: stateData.method,
                      items: methods,
                      onChanged: isLoading
                          ? null
                          : (v) => notifier.updateMethod(v!),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: DropdownWidget<int>(
                      label: 'STATUS',
                      initialValue: stateData.statusCode,
                      items: statusCodes,
                      onChanged: isLoading
                          ? null
                          : (v) => notifier.updateStatus(v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              DropdownWidget<int>(
                label: 'MAX RETRIES',
                initialValue: stateData.maxRetries,
                items: retryOptions,
                itemLabelBuilder: (value) => '$value Attempts',
                onChanged: isLoading
                    ? null
                    : (v) => notifier.updateRetryCount(v!),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Delay logic: 2s * (attempt + 1). Example: 2s, 4s, 6s...',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withAlpha(128),
                  fontSize: 10.0,
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
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
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
                      CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                        strokeWidth: 2.0,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'WAITING FOR RESPONSE...',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          color: theme.colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                )
              else if (stateData.result.isNotEmpty) ...<Widget>[
                _sectionTitle('METRICS & PERFORMANCE', theme),
                const SizedBox(height: 12.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _metricTile(
                        'Latency',
                        stateData.duration,
                        Icons.speed,
                        theme,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: _metricTile(
                        'Retry Count',
                        '${stateData.actualRetries}',
                        Icons.refresh,
                        theme,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                _sectionTitle('RESPONSE BODY', theme),
                const SizedBox(height: 12.0),
                _codeBlock(
                  stateData.result,
                  theme.colorScheme.surfaceContainerHighest,
                  theme,
                ),
                const SizedBox(height: 24.0),
                _sectionTitle('HEADERS', theme),
                const SizedBox(height: 12.0),
                _codeBlock(
                  stateData.headers,
                  theme.colorScheme.surfaceContainerHighest.withAlpha(179),
                  theme,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: TextStyle(
        color: theme.colorScheme.onSurface.withAlpha(128),
        fontSize: 11.0,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _metricTile(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: 16.0,
            color: theme.colorScheme.onSurface.withAlpha(153),
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(128),
              fontSize: 11.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _codeBlock(String content, Color color, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Text(
        content,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 11.0,
          fontFamily: 'monospace',
          height: 1.5,
        ),
      ),
    );
  }
}
