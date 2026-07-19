import 'package:ai_diary_hands_on/core/ai/firebase_ai_provider.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'calendar_api_service.dart';
import 'calendar_event.dart';

part 'calendar_ai_assistant.g.dart';

@Riverpod(keepAlive: true)
CalendarAiAssistant calendarAiAssistant(Ref ref) => CalendarAiAssistant(ref);

class CalendarAiAssistant {
  CalendarAiAssistant(this._ref);
  final Ref _ref;

  Future<CalendarEvent?> createEventIfNeeded({
    required String content,
  }) async {
    final model = _ref
        .read(firebaseAIProvider)
        .generativeModel(
          model: 'gemini-3.1-flash-lite',
          tools: [
            Tool.functionDeclarations([_addEventToCalendarTool]),
          ],
          systemInstruction: Content.system(_systemPrompt),
        );
    final response = await model.generateContent([
      Content.text(
        '現在の日時は${DateTime.now().toIso8601String()}です。日記の内容: $content',
      ),
    ]);
    for (final call in response.functionCalls) {
      switch (call.name) {
        case 'addEventToCalendar':
          final event = CalendarEvent.fromJson(
            call.args['result']! as Map<String, dynamic>,
          );
          await _ref.read(calendarApiServiceProvider).addEvent(event);
          return event;
        default:
          throw Exception('Unknown function call: ${call.name}');
      }
    }
    return null;
  }
}

final _addEventToCalendarTool = FunctionDeclaration(
  'addEventToCalendar',
  '日記の内容からカレンダーに予定を追加する',
  parameters: {
    'result': Schema.object(
      properties: {
        'title': Schema.string(description: '予定のタイトル'),
        'description': Schema.string(description: '予定の説明'),
        'startTime': Schema.string(description: '開始日時（ISO 8601形式）'),
        'endTime': Schema.string(description: '終了日時（ISO 8601形式）'),
      },
      optionalProperties: ['endTime'],
    ),
  },
);

const _systemPrompt = '''
あなたのタスクは日記の内容を分析し、必要に応じてカレンダーに予定を追加することです。
次の手順で処理してください。

1. 日記の内容を分析し、予定として登録すべき内容があるか判断してください
2. 予定を追加する必要がある場合、"明日"や"来週"などの相対的な表現は、現在の日付を元に具体的な日時に変換してください
3. `addEventToCalendar`ツールを使用してカレンダーに予定を追加してください

予定を追加する必要がない場合は、何もしないでください。
''';
