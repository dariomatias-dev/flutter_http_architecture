import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/core/constants/methods.dart';
import 'package:flutter_http_architecture/src/core/constants/retry_attempts.dart';

import 'package:flutter_http_architecture/src/features/http_workbench/di/http_workbench_providers.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/domain/entities/http_advanced_item.dart';

import 'package:flutter_http_architecture/src/shared/widgets/button_widget.dart';
import 'package:flutter_http_architecture/src/shared/widgets/dropdown_widget.dart';
import 'package:flutter_http_architecture/src/shared/widgets/input_field_widget.dart';

class HttpAdvancedScreen extends ConsumerWidget {
  const HttpAdvancedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(httpAdvancedProvider);
    final notifier = ref.read(httpAdvancedProvider.notifier);

    final theme = Theme.of(context);

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
              initialValue: state.method,
              items: methods,
              onChanged: (v) => notifier.updateMethod(v!),
            ),
            const SizedBox(height: 16.0),
            InputFieldWidget(
              initialValue: state.url,
              label: 'URL ENDPOINT',
              onChanged: notifier.updateUrl,
            ),
            const SizedBox(height: 28.0),
            _DynamicInputSection<HttpAdvancedItem>(
              title: 'QUERY PARAMETERS',
              items: state.queryParams,
              onAdd: notifier.addQueryParam,
              itemBuilder: (item, index) => _DynamicKeyValueRow(
                key: ValueKey(item.id),
                initialKey: item.key,
                initialValue: item.value,
                onKeyChanged: (v) {
                  notifier.updateQueryParam(item.id, key: v);
                },
                onValueChanged: (v) {
                  notifier.updateQueryParam(item.id, value: v);
                },
                onDelete: () => notifier.removeQueryParam(item.id),
              ),
            ),
            const SizedBox(height: 20.0),
            _DynamicInputSection<HttpAdvancedItem>(
              title: 'HEADERS',
              items: state.headers,
              onAdd: notifier.addHeader,
              itemBuilder: (item, index) => _DynamicKeyValueRow(
                key: ValueKey(item.id),
                initialKey: item.key,
                initialValue: item.value,
                onKeyChanged: (v) {
                  notifier.updateHeader(item.id, key: v);
                },
                onValueChanged: (v) {
                  notifier.updateHeader(item.id, value: v);
                },
                onDelete: () {
                  notifier.removeHeader(item.id);
                },
              ),
            ),
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
                    initialValue: state.maxRetries,
                    items: retryAttempts,
                    itemLabelBuilder: (v) => '$v Attempts',
                    onChanged: (v) => notifier.updateRetries(v!),
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
            const SizedBox(height: 32.0),
            ButtonWidget(
              label: 'EXECUTE REQUEST',
              onPressed: () {},
              isLoading: state.isLoading,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Divider(),
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
            tabs: const <Tab>[
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
                      hintText: '{\n "id": 1,\n "name": "tester"\n}',
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

  InputDecoration _inputStyle(String label, ThemeData theme) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: theme.colorScheme.onSurface.withAlpha(150),
        fontSize: 9.0,
        fontWeight: FontWeight.w900,
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
}

class _DynamicInputSection<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final VoidCallback onAdd;
  final Widget Function(T item, int index) itemBuilder;

  const _DynamicInputSection({
    required this.title,
    required this.items,
    required this.onAdd,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(128),
                fontSize: 10.0,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
            TextButton.icon(
              onPressed: onAdd,
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              icon: const Icon(Icons.add, size: 14.0),
              label: const Text(
                'ADD',
                style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'No items added.',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(80),
                fontSize: 11.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ...List.generate(
            items.length,
            (index) => itemBuilder(items[index], index),
          ),
      ],
    );
  }
}

class _DynamicKeyValueRow extends StatelessWidget {
  final String initialKey;
  final String initialValue;
  final ValueChanged<String> onKeyChanged;
  final ValueChanged<String> onValueChanged;
  final VoidCallback onDelete;

  const _DynamicKeyValueRow({
    super.key,
    required this.initialKey,
    required this.initialValue,
    required this.onKeyChanged,
    required this.onValueChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InputFieldWidget(
              initialValue: initialKey,
              label: 'KEY',
              onChanged: onKeyChanged,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: InputFieldWidget(
              initialValue: initialValue,
              label: 'VALUE',
              onChanged: onValueChanged,
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline,
              size: 18.0,
              color: theme.colorScheme.error.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }
}
