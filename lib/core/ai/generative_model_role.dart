import 'package:flutter/services.dart';

enum GenerativeModelRole {
  /// AIフィードバックのための指示
  aiFeedback(
    systemInstructionFile: 'assets/prompts/ai_feedback_prompt.md',
  ),
  chat(
    systemInstructionFile: 'assets/prompts/chat_prompt.md',
  ),
  ;

  const GenerativeModelRole({required this.systemInstructionFile}); // ④
  final String systemInstructionFile; // ⑤

  Future<String> get systemInstruction => // ⑥
      rootBundle.loadString(systemInstructionFile);
}
