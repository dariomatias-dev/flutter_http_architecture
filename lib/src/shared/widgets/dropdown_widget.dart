import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatelessWidget {
  final String label;
  final T initialValue;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final String Function(T value)? itemLabelBuilder;

  const DropdownWidget({
    super.key,
    required this.label,
    required this.initialValue,
    required this.items,
    this.onChanged,
    this.itemLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<T>(
      initialValue: initialValue,
      dropdownColor: theme.colorScheme.surface,
      elevation: 2,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: 13.0,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(179),
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
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
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabelBuilder != null
                ? itemLabelBuilder!(item)
                : item.toString(),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
