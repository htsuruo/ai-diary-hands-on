import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String text,
    required MessageRole role,
    required DateTime timestamp,
  }) = _ChatMessage;
  const ChatMessage._();
}

enum MessageRole {
  user,
  model,
  ;

  bool get isUser => this == MessageRole.user;
}
