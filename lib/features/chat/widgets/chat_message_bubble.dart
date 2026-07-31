import 'package:ai_diary_hands_on/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../chat_message.dart';
import '../grounding_source.dart';

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
      child: Column(
        children: [
          MarkdownBody(
            data: message.text,
            selectable: true,
          ),
          if (message.sources.isNotEmpty) ...[
            const Gap(8),
            _SourceChips(sources: message.sources),
          ],
        ],
      ),
    );
  }
}

class _SourceChips extends StatelessWidget {
  const _SourceChips({required this.sources});

  final List<GroundingSource> sources;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      children: sources.map((source) {
        return ActionChip(
          label: Text(source.title.isEmpty ? '参照元リンク' : source.title),
          avatar: const Icon(Icons.link, size: 16),
          onPressed: () async {
            final url = Uri.parse(source.uri);
            final launched = await launchUrl(url);
            if (!launched) {
              logger.warning('Could not launch $url');
            }
          },
          tooltip: source.uri,
          side: BorderSide(color: theme.colorScheme.outlineVariant),
          backgroundColor: theme.colorScheme.surface,
        );
      }).toList(),
    );
  }
}
