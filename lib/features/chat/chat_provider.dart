import 'package:ai_diary_hands_on/core/ai/firebase_ai_provider.dart';
import 'package:ai_diary_hands_on/core/ai/generative_model_role.dart';
import 'package:ai_diary_hands_on/features/diary/diary.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'chat_message.dart';
import 'grounding_source.dart';

part 'chat_provider.freezed.dart';
part 'chat_provider.g.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<ChatMessage> messages,
    @Default(false) bool isSending,
    required ChatSession session,
  }) = _ChatState;

  const ChatState._();
}

@riverpod
class Chat extends _$Chat {
  @override
  Future<ChatState> build(String diaryId) async {
    final diary = await ref.watch(diaryProvider(diaryId).future);
    final model = ref
        .watch(firebaseAIProvider)
        .generativeModel(
          model: 'gemini-3.1-flash-lite',
          systemInstruction: Content.system(
            await GenerativeModelRole.chat.systemInstruction,
          ),
          tools: [Tool.googleSearch()], // 6.3.4で追記
        );
    final content = diary!.content; // 詳細画面にきているのでnull考慮しない
    final feedback = diary.feedback;
    final chatSession = model.startChat(
      history: [
        Content.text(content),
        Content.model([TextPart(feedback)]),
      ],
    );
    return ChatState(
      messages: [
        _makeUserMessage(content),
        _makeModelMessage(feedback),
      ],
      session: chatSession,
    );
  }

  // 6.3.5で追記（Grounding）
  Future<void> sendMessage(String text) async {
    final userMessage = _makeUserMessage(text);
    _addMessage(message: userMessage, isSending: true);

    final groundingSourceChunks = <GroundingSource>{};
    String? searchSuggestionsHtml;

    final stream = state.requireValue.session.sendMessageStream(
      Content.text(text),
    );
    final buffer = StringBuffer();

    await for (final chunk in stream) {
      final metadata = chunk.candidates.first.groundingMetadata;
      if (metadata != null) {
        searchSuggestionsHtml =
            metadata.searchEntryPoint?.renderedContent ?? searchSuggestionsHtml;
        groundingSourceChunks.addAll(
          metadata.groundingChunks.map(
            (g) => GroundingSource(
              uri: g.web?.uri ?? '',
              title: g.web?.title ?? '',
            ),
          ),
        );
      }

      final textChunk = chunk.text;
      if (textChunk == null) {
        continue;
      }

      /// バッファが空な状態を最初のchunkとして判定
      if (buffer.isEmpty) {
        final newMessage = _makeModelMessage(textChunk);
        _addMessage(message: newMessage, isSending: false);
        buffer.write(textChunk);
        continue;
      }

      // 既にメッセージがある場合は、最後のメッセージを更新
      buffer.write(textChunk);
      _updateLastMessage(buffer.toString());
    }

    // ストリーミング完了後、収集したグラウンディング情報をメッセージに反映
    if (groundingSourceChunks.isNotEmpty || searchSuggestionsHtml != null) {
      final sources = groundingSourceChunks
          .where((s) => s.uri.isNotEmpty)
          .toList();
      _updateLastMessage(
        buffer.toString(),
        sources: sources,
        searchSuggestionsHtml: searchSuggestionsHtml,
      );
    }
  }

  // メッセージステートの更新
  void _addMessage({required ChatMessage message, required bool isSending}) {
    state = AsyncData(
      state.requireValue.copyWith(
        messages: [...state.requireValue.messages, message],
        isSending: isSending,
      ),
    );
  }

  // 6.3.5で追記（Grounding）
  void _updateLastMessage(
    String text, {
    List<GroundingSource>? sources,
    String? searchSuggestionsHtml,
  }) {
    final messages = state.requireValue.messages;
    state = AsyncData(
      state.requireValue.copyWith(
        messages: [
          ...messages.sublist(0, messages.length - 1),
          messages.last.copyWith(
            text: text,
            sources: sources ?? messages.last.sources,
            searchSuggestionsHtml:
                searchSuggestionsHtml ?? messages.last.searchSuggestionsHtml,
          ),
        ],
      ),
    );
  }

  // Future<void> sendMessage(String text) async {
  //   final currentState = state.requireValue;

  //   final userMessage = _makeUserMessage(text);
  //   state = AsyncData(
  //     currentState.copyWith(
  //       messages: [...currentState.messages, userMessage],
  //       isSending: true,
  //     ),
  //   );

  //   final stream = state.requireValue.session.sendMessageStream(

  //     Content.text(text),
  //   );
  //   final buffer = StringBuffer();

  //   await for (final chunk in stream) {

  //     final textChunk = chunk.text;
  //     if (textChunk == null) {
  //       continue;
  //     }

  //     if (buffer.isEmpty) {

  //       // 最初のチャンクで新しいメッセージを作成
  //       final newMessage = _makeModelMessage(textChunk);
  //       state = AsyncData(
  //         state.requireValue.copyWith(
  //           messages: [...state.requireValue.messages, newMessage],
  //         ),
  //       );
  //       buffer.write(textChunk);
  //     } else {
  //       // 後続のチャンクで最後のメッセージを更新
  //       buffer.write(textChunk);
  //       _updateLastMessage(buffer.toString());
  //     }
  //   }

  //   state = AsyncData(
  //     state.requireValue.copyWith(isSending: false),
  //   );
  // }

  // void _updateLastMessage(String text) {
  //   final messages = state.requireValue.messages;
  //   state = AsyncData(
  //     state.requireValue.copyWith(
  //       messages: [

  //         ...messages.sublist(0, messages.length - 1),
  //         messages.last.copyWith(text: text),
  //       ],
  //     ),
  //   );
  // }
}

ChatMessage _makeUserMessage(String message) => ChatMessage(
  text: message,
  role: .user,
  timestamp: DateTime.now(),
);

ChatMessage _makeModelMessage(String message) => ChatMessage(
  text: message,
  role: .model,
  timestamp: DateTime.now(),
);
