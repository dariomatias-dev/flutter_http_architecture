import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/core/constants/methods.dart';
import 'package:flutter_http_architecture/src/core/constants/retry_attempts.dart';

import 'package:flutter_http_architecture/src/features/http_tester/di/http_tester_providers.dart';
import 'package:flutter_http_architecture/src/features/http_tester/presentation/widgets/response_section_widget.dart';

import 'package:flutter_http_architecture/src/shared/widgets/button_widget.dart';
import 'package:flutter_http_architecture/src/shared/widgets/dropdown_widget.dart';

class HttpPlaygroundScreen extends ConsumerWidget {
  const HttpPlaygroundScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final asyncState = ref.watch(httpTesterNotifierProvider);
    final notifier = ref.read(httpTesterNotifierProvider.notifier);

    final stateData = asyncState.requireValue;
    final isLoading = asyncState.isLoading;

    return DefaultTabController(
      length: 3,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _sectionTitle('REQUEST CONFIGURATION', theme),
            const SizedBox(height: 16.0),
            DropdownWidget<String>(
              label: 'METHOD',
              initialValue: stateData.method,
              items: methods,
              onChanged: isLoading ? null : (v) => notifier.updateMethod(v!),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              initialValue: 'https://api.example.com/v1/resource',
              style: const TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
              ),
              decoration: _inputStyle('URL ENDPOINT', theme),
            ),
            const SizedBox(height: 28.0),
            _sectionHeader('QUERY PARAMETERS', theme, onAdd: () {}),
            _dynamicKeyValueRow(theme, 'page', '1'),
            const SizedBox(height: 20.0),
            _sectionHeader('HEADERS', theme, onAdd: () {}),
            _dynamicKeyValueRow(theme, 'Content-Type', 'application/json'),
            const SizedBox(height: 28.0),
            _sectionTitle('REQUEST BODY', theme),
            const SizedBox(height: 12.0),
            _buildBodyEditor(theme),
            const SizedBox(height: 28.0),
            _sectionTitle('ADVANCED SETTINGS', theme),
            const SizedBox(height: 12.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: DropdownWidget<int>(
                    label: 'RETRIES',
                    initialValue: stateData.maxRetries,
                    items: retryAttempts,
                    itemLabelBuilder: (v) => '$v Attempts',
                    onChanged: (v) => notifier.updateRetryCount(v!),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: TextFormField(
                    initialValue: '30000',
                    decoration: _inputStyle('TIMEOUT (ms)', theme),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: const Text(
                'Auto-retry on 5xx errors',
                style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
              ),
              value: true,
              activeThumbColor: theme.colorScheme.primary,
              onChanged: (v) {},
            ),
            const SizedBox(height: 32.0),
            ButtonWidget(
              label: 'EXECUTE REQUEST',
              onPressed: notifier.runRequest,
              isLoading: isLoading,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
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
      ),
    );
  }

  Widget _buildBodyEditor(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: <Widget>[
          TabBar(
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withAlpha(128),
            labelStyle: const TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: 'JSON'),
              Tab(text: 'FORM-DATA'),
              Tab(text: 'RAW'),
            ],
          ),
          SizedBox(
            height: 160,
            child: TabBarView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    maxLines: 6,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12.0,
                    ),
                    decoration: InputDecoration(
                      hintText: '{\n  "id": 1,\n  "name": "tester"\n}',
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withAlpha(60),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Center(child: Text('Form-data Editor')),
                const Center(child: Text('Raw Editor')),
              ],
            ),
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

  Widget _sectionHeader(
    String title,
    ThemeData theme, {
    required VoidCallback onAdd,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _sectionTitle(title, theme),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 14.0),
          label: const Text(
            'ADD',
            style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _dynamicKeyValueRow(ThemeData theme, String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              initialValue: k,
              decoration: _inputStyle('KEY', theme),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: TextFormField(
              initialValue: v,
              decoration: _inputStyle('VALUE', theme),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete_outline,
              size: 18.0,
              color: theme.colorScheme.onSurface.withAlpha(100),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputStyle(String label, ThemeData theme) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontSize: 9.0,
        fontWeight: FontWeight.w900,
        color: theme.colorScheme.onSurface.withAlpha(150),
      ),
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
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
