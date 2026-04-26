import 'package:flutter/material.dart';

class InputFieldWidget extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final String? label;

  const InputFieldWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.label,
  });

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {});

      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: _controller,
      style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
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
        suffixIcon: _controller.text.isNotEmpty
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
