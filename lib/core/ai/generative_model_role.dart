import 'package:flutter/services.dart';

enum GenerativeModelRole {
  // AIフィードバックのための指示
  aiFeedback(
    systemInstructionFile: 'assets/prompts/ai_feedback_prompt.md',
  ),

  // チャットメンタリングのための指示
  chat(
    systemInstructionFile: 'assets/prompts/chat_prompt.md',
  ),
  ;

  const GenerativeModelRole({required this.systemInstructionFile});
  final String systemInstructionFile;

  Future<String> get systemInstruction =>
      rootBundle.loadString(systemInstructionFile);
}
