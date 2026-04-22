import 'package:flutter/material.dart';

class MetricTileWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const MetricTileWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: theme.colorScheme.outlineVariant),
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
}
