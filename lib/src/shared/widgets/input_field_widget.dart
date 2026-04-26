import 'package:flutter/material.dart';

class InputFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final int? maxLines;
  final TextStyle? textStyle;
  final bool enabled;

  const InputFieldWidget({
    super.key,
    this.controller,
    this.label,
    this.maxLines,
    this.textStyle,
    this.enabled = true,
  });

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  late final _controller = widget.controller ?? TextEditingController();

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: _controller,
      enabled: widget.enabled,
      maxLines: widget.maxLines ?? 1,
      style:
          widget.textStyle ??
          const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: widget.label,
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
        suffixIcon: _controller.text.isNotEmpty && widget.enabled
            ? IconButton(
                onPressed: _controller.clear,
                icon: const Icon(Icons.clear, size: 20.0),
              )
            : null,
      ),
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }
}
