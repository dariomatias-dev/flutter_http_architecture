import 'package:flutter/material.dart';

import 'package:flutter_http_architecture/src/shared/widgets/metric_tile_widget.dart';

class ResponseSectionWidget extends StatelessWidget {
  final String duration;
  final int actualRetries;
  final String body;
  final String headers;

  const ResponseSectionWidget({
    super.key,
    required this.duration,
    required this.actualRetries,
    required this.body,
    required this.headers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _sectionTitle('METRICS & PERFORMANCE', theme),
        const SizedBox(height: 12.0),
        Row(
          children: <Widget>[
            Expanded(
              child: MetricTileWidget(
                label: 'Latency',
                value: duration,
                icon: Icons.speed,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: MetricTileWidget(
                label: 'Retry Count',
                value: '$actualRetries',
                icon: Icons.refresh,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        _sectionTitle('RESPONSE BODY', theme),
        const SizedBox(height: 12.0),
        _codeBlock(body, theme.colorScheme.surfaceContainerHighest, theme),
        const SizedBox(height: 24.0),
        _sectionTitle('HEADERS', theme),
        const SizedBox(height: 12.0),
        _codeBlock(
          headers,
          theme.colorScheme.surfaceContainerHighest.withAlpha(179),
          theme,
        ),
      ],
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
