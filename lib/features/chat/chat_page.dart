import 'package:ai_diary_hands_on/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/chat_input_field.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key, required this.diaryId});

  final String diaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チャット'),
      ),
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: EmptyWidget(
                icon: Icons.chat_bubble_outline,
                title: '会話をはじめましょう',
              ),
            ),
          ),
          ChatInputField(
            isLoading: false,
            onSubmitted: (_) async {},
          ),
        ],
      ),
    );
  }
}
