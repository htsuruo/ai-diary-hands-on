import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    super.key,
    required this.isLoading,
    required this.onSubmitted,
  });

  final bool isLoading;
  final Future<void> Function(String) onSubmitted;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Future<void> submitChatText(String text) async {
      _textController.clear();
      await widget.onSubmitted(text.trim());
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const .all(16),
      child: SafeArea(
        child: ListenableBuilder(
          listenable: _textController,
          builder: (context, _) {
            final isEmpty = _textController.text.trim().isEmpty;

            return TextField(
              autofocus: true,
              maxLines: null,
              controller: _textController,
              onSubmitted: submitChatText,
              enabled: !widget.isLoading,
              textInputAction: .send,
              decoration: InputDecoration(
                hintText: 'フィードバックの相談',
                hintStyle: theme.textTheme.bodyMedium!.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                contentPadding: const .only(
                  left: 20,
                  right: 56,
                ),
                border: OutlineInputBorder(
                  borderRadius: .circular(40),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Padding(
                  padding: const .all(4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: IconButton.filled(
                      onPressed: isEmpty || widget.isLoading
                          ? null
                          : () => submitChatText(_textController.text),
                      icon: const Icon(Icons.arrow_upward),
                      style: IconButton.styleFrom(
                        foregroundColor: colorScheme.onPrimary,
                        disabledForegroundColor: theme.disabledColor,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
