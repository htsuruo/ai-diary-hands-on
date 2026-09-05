import 'package:firebase_ai/firebase_ai.dart';

Future<String?> generateText() async {
  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.5-flash-lite',
  );

  final prompt = [
    Content.text('魔法のバックパックについての物語を書いてください。'),
  ];

  final response = await model.generateContent(prompt);
  return response.text;
}
