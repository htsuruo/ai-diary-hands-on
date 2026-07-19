import 'package:firebase_ai/firebase_ai.dart'; // ①

Future<String?> generateText() async {
  final model = FirebaseAI.googleAI().generativeModel(
    // ②
    model: 'gemini-3.1-flash-lite',
  );

  final prompt = [
    Content.text('魔法のバックパックについての物語を書いてください。'), // ③
  ];

  final response = await model.generateContent(prompt); // ④
  return response.text; // ⑤
}
