import 'package:ai_diary_hands_on/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat_provider.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/chat_message_bubble.dart';

final GlobalKey _lastUserMessageKey = GlobalKey();

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key, required this.diaryId});

  final String diaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(chatProvider(diaryId)).value;
    final messages = chat?.messages ?? [];
    final isSending = chat?.isSending ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messages.isEmpty) {
        return;
      }
      final lastMessage = messages.last;
      if (lastMessage.role.isUser) {
        final context = _lastUserMessageKey.currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCirc,
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('チャット'),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: EmptyWidget(
                      icon: Icons.chat_bubble_outline,
                      title: '会話をはじめましょう',
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        for (final message in messages)
                          ChatMessageBubble(
                            key: message.role.isUser && message == messages.last
                                ? _lastUserMessageKey
                                : null,
                            message: message,
                          ),
                        if (isSending)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: CenteredCircularIndicator(),
                          ),
                      ],
                    ),
                  ),
          ),
          ChatInputField(
            isLoading: isSending,
            onSubmitted: (text) =>
                ref.read(chatProvider(diaryId).notifier).sendMessage(text),
          ),
        ],
      ),
    );
  }
}
