import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/core/constants/methods.dart';
import 'package:flutter_http_architecture/src/core/constants/retry_attempts.dart';

import 'package:flutter_http_architecture/src/features/http_tester/di/http_tester_providers.dart';
import 'package:flutter_http_architecture/src/features/http_tester/presentation/widgets/response_section_widget.dart';

import 'package:flutter_http_architecture/src/shared/widgets/button_widget.dart';
import 'package:flutter_http_architecture/src/shared/widgets/dropdown_widget.dart';

class HttpTesterScreen extends ConsumerWidget {
  const HttpTesterScreen({super.key});

  final statusCodes = const <int>[200, 201, 401, 404, 429, 500, 503, 504];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final asyncState = ref.watch(httpTesterNotifierProvider);
    final notifier = ref.read(httpTesterNotifierProvider.notifier);

    final stateData = asyncState.requireValue;
    final isLoading = asyncState.isLoading;

    return SingleChildScrollView(
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
            items: retryAttempts,
            itemLabelBuilder: (value) => '$value Attempts',
            onChanged: isLoading ? null : (v) => notifier.updateRetryCount(v!),
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
          ButtonWidget(
            label: 'EXECUTE REQUEST',
            onPressed: notifier.runRequest,
            isLoading: isLoading,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 28.0),
            child: Divider(),
          ),
          if (isLoading)
            _loadingState(theme)
          else if (stateData.result.isNotEmpty)
            ResponseSectionWidget(
              duration: stateData.duration,
              actualRetries: stateData.actualRetries,
              body: stateData.result,
              headers: stateData.headers,
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: TextStyle(
        color: theme.colorScheme.onSurface.withAlpha(128),
        fontSize: 10.0,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _loadingState(ThemeData theme) {
    return Center(
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
    );
  }
}
