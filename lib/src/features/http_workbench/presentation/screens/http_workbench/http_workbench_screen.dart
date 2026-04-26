import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/core/di/theme_notifier_provider.dart';

import 'package:flutter_http_architecture/src/features/http_workbench/di/http_workbench_providers.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/providers/http_mode_notifier.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/screens/http_advanced/http_advanced_screen.dart';
import 'package:flutter_http_architecture/src/features/http_workbench/presentation/screens/http_simple/http_simple_screen.dart';

class HttpWorkbenchScreen extends ConsumerWidget {
  const HttpWorkbenchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mode = ref.watch(httpModeProvider);
    final notifier = ref.read(httpModeProvider.notifier);

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
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(
                    100,
                  ),
                ),
                padding: const EdgeInsets.all(4.0),
                child: SegmentedButton<HttpMode>(
                  showSelectedIcon: false,
                  selected: <HttpMode>{mode},
                  onSelectionChanged: (selection) => notifier.toggle(),
                  style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return theme.colorScheme.primary;
                      }
                      return Colors.transparent;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return theme.colorScheme.onPrimary;
                      }
                      return theme.colorScheme.onSurfaceVariant.withAlpha(180);
                    }),
                    textStyle: WidgetStateProperty.all(
                      const TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.6,
                      ),
                    ),
                    side: WidgetStateProperty.all(BorderSide.none),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 18.0),
                    ),
                  ),
                  segments: const <ButtonSegment<HttpMode>>[
                    ButtonSegment<HttpMode>(
                      value: HttpMode.simple,
                      label: Text('SIMPLE'),
                    ),
                    ButtonSegment<HttpMode>(
                      value: HttpMode.advanced,
                      label: Text('ADVANCED'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: mode == HttpMode.simple
                  ? const HttpSimpleScreen()
                  : const HttpAdvancedScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
