import 'dart:convert';

import 'package:ai_diary_hands_on/core/ai/firebase_ai_provider.dart';
import 'package:ai_diary_hands_on/features/diary/diary.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'sentiment.dart';
import 'sentiment_state.dart';

part 'sentiment_analysis_provider.g.dart';

@riverpod
class SentimentAnalysis extends _$SentimentAnalysis {
  @override
  FutureOr<SentimentState?> build({required DiaryEntry diary}) =>
      diary.sentimentAnalysis;

  Future<void> analyze() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final model = ref
          .read(firebaseAIProvider)
          .generativeModel(
            model: 'gemini-3.1-flash-lite',
          );
      final response = await model.generateContent(
        [
          Content.text(
            '次の内容をセンチメント分析（感情分析）して: ${this.diary.content}',
          ),
        ],
        generationConfig: GenerationConfig(
          // ①
          responseMimeType: 'application/json', // ②
          responseSchema: Schema.object(
            // ③
            properties: {
              'sentiment': Schema.enumString(
                description: 'センチメント分析の結果',
                enumValues: Sentiment.values.map((e) => e.name).toList(), // ④
              ),
              'reason': Schema.string(
                description: '分析結果の理由を簡潔に記載する',
              ),
            },
            nullable: false, // ⑤
          ),
        ),
      );
      final json = jsonDecode(response.text!) as Map<String, dynamic>; // ①
      return SentimentState.fromJson(json);
    });

    if (!state.hasError) {
      final diary = this.diary.copyWith(
        sentimentAnalysis: state.value, // ①
      );
      await ref.read(diaryRepositoryProvider.notifier).updateEntry(diary); // ②
    }
  }
}
