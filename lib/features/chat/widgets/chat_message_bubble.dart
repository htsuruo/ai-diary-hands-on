import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
  });
  final ChatMessage message;
  @override
  Widget build(BuildContext context) {
    final isUser = message.role.isUser;
    final text = message.text;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: isUser
                ? _UserMessageWidget(text: text)
                : _ModelMessageWidget(message: message),
          ),
        ],
      ),
    );
  }
}

class _UserMessageWidget extends StatelessWidget {
  const _UserMessageWidget({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.widthOf(context);

    return Container(
      constraints: BoxConstraints(maxWidth: width * 0.8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20).copyWith(
          topRight: const Radius.circular(4),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Text(text),
    );
  }
}

class _ModelMessageWidget extends StatelessWidget {
  const _ModelMessageWidget({required this.message});
  final ChatMessage message;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.widthOf(context);
    return Container(
      constraints: BoxConstraints(maxWidth: width * 0.9),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(
          alpha: 0.6,
        ),
        borderRadius: BorderRadius.circular(16).copyWith(
          topLeft: const Radius.circular(4),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: MarkdownBody(
        data: message.text,
        selectable: true,
      ),
    );
  }
}
