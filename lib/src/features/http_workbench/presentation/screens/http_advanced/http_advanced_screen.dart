import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/core/constants/api_urls.dart';
import 'package:flutter_http_architecture/src/core/constants/methods.dart';

import 'package:flutter_http_architecture/src/features/http_workbench/di/http_workbench_providers.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/widgets/response_section_widget.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/viewmodels/http_advanced_state.dart';

import 'package:flutter_http_architecture/src/shared/widgets/button_widget.dart';
import 'package:flutter_http_architecture/src/shared/widgets/dropdown_widget.dart';
import 'package:flutter_http_architecture/src/shared/widgets/input_field_widget.dart';

class HttpAdvancedScreen extends ConsumerStatefulWidget {
  const HttpAdvancedScreen({super.key});

  @override
  ConsumerState<HttpAdvancedScreen> createState() => _HttpAdvancedScreenState();
}

class _HttpAdvancedScreenState extends ConsumerState<HttpAdvancedScreen> {
  final _urlConctroller = TextEditingController(text: ApiUrls.httpbin);
  final _bodyController = TextEditingController(
    text: '{\n "id": 1,\n "name": "tester"\n}',
  );

  String _selectedMethod = methods.first;
  final _headers = <_ItemControllers>[_ItemControllers()];
  final _queryParams = <_ItemControllers>[_ItemControllers()];

  void _addHeader() => setState(() => _headers.add(_ItemControllers()));

  void _addQueryParam() => setState(() => _queryParams.add(_ItemControllers()));

  void _removeItem(List<_ItemControllers> list, int index) {
    setState(() {
      list[index].dispose();
      list.removeAt(index);
    });
  }

  Future<void> _onExecute() async {
    final notifier = ref.read(httpAdvancedProvider.notifier);

    await notifier.executeRequest(
      method: _selectedMethod,
      url: _urlConctroller.text,
      body: _bodyController.text,
      headers: _headers.map((e) => e.toMap()).toList(),
      queryParams: _queryParams.map((e) => e.toMap()).toList(),
    );
  }

  @override
  void dispose() {
    _urlConctroller.dispose();
    _bodyController.dispose();

    for (final item in _headers) {
      item.dispose();
    }

    for (final item in _queryParams) {
      item.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(httpAdvancedProvider);
    final isLoading = state.isLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader('REQUEST CONFIGURATION'),
          const SizedBox(height: 16.0),
          DropdownWidget<String>(
            label: 'METHOD',
            initialValue: _selectedMethod,
            items: methods,
            onChanged: isLoading
                ? null
                : (v) => setState(() => _selectedMethod = v!),
          ),
          const SizedBox(height: 16.0),
          InputFieldWidget(
            controller: _urlConctroller,
            label: 'URL ENDPOINT',
            enabled: !isLoading,
          ),
          const SizedBox(height: 28.0),
          _DynamicSection(
            title: 'QUERY PARAMETERS',
            items: _queryParams,
            isLoading: isLoading,
            onAdd: _addQueryParam,
            onRemove: (i) => _removeItem(_queryParams, i),
          ),
          _DynamicSection(
            title: 'HEADERS',
            items: _headers,
            isLoading: isLoading,
            onAdd: _addHeader,
            onRemove: (i) => _removeItem(_headers, i),
          ),
          const _SectionHeader('REQUEST BODY'),
          const SizedBox(height: 12.0),
          InputFieldWidget(
            controller: _bodyController,
            maxLines: 6,
            enabled: !isLoading,
            textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 12.0),
          ),
          const SizedBox(height: 32.0),
          ButtonWidget(
            label: 'EXECUTE REQUEST',
            onPressed: _onExecute,
            isLoading: isLoading,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Divider(),
          ),
          _ResponseArea(state: state),
        ],
      ),
    );
  }
}

class _DynamicSection extends StatelessWidget {
  final String title;
  final List<_ItemControllers> items;
  final bool isLoading;
  final VoidCallback onAdd;
  final Function(int value) onRemove;

  const _DynamicSection({
    required this.title,
    required this.items,
    required this.isLoading,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _SectionHeader(title),
            TextButton.icon(
              onPressed: isLoading ? null : onAdd,
              icon: const Icon(Icons.add, size: 14.0),
              label: const Text(
                'ADD',
                style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'No items added.',
              style: TextStyle(
                fontSize: 11.0,
                fontStyle: FontStyle.italic,
                color: Colors.grey.withAlpha(153),
              ),
            ),
          )
        else
          ...List<Widget>.generate(items.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InputFieldWidget(
                      label: 'KEY',
                      controller: items[index].key,
                      enabled: !isLoading,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: InputFieldWidget(
                      label: 'VALUE',
                      controller: items[index].value,
                      enabled: !isLoading,
                    ),
                  ),
                  IconButton(
                    onPressed: isLoading ? null : () => onRemove(index),
                    icon: Icon(
                      Icons.delete_outline,
                      size: 18.0,
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withAlpha(isLoading ? 64 : 178),
                    ),
                  ),
                ],
              ),
            );
          }),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

class _ResponseArea extends StatelessWidget {
  final AsyncValue<HttpAdvancedState> state;

  const _ResponseArea({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) return const _LoadingState();

    final data = state.value?.response;
    if (data == null) return const SizedBox.shrink();

    return ResponseSectionWidget(
      duration: '${data.context?.duration?.inMilliseconds ?? 0}ms',
      actualRetries: data.context?.retryCount ?? 0,
      body: data.isSuccess
          ? jsonEncode(data.data)
          : (data.error?.message ?? 'Request Failed'),
      headers: jsonEncode(data.headers ?? <String, dynamic>{}),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
        fontSize: 10.0,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface.withAlpha(153);

    return Center(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 40.0),
          const CircularProgressIndicator(strokeWidth: 2.0),
          const SizedBox(height: 16.0),
          Text(
            'WAITING FOR RESPONSE...',
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemControllers {
  final TextEditingController key;
  final TextEditingController value;

  _ItemControllers({String initialKey = '', String initialValue = ''})
    : key = TextEditingController(text: initialKey),
      value = TextEditingController(text: initialValue);

  Map<String, String> toMap() {
    return <String, String>{'key': key.text, 'value': value.text};
  }

  void dispose() {
    key.dispose();
    value.dispose();
  }
}
