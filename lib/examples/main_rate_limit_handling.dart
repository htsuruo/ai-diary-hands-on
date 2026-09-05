import 'package:ai_diary_hands_on/firebase_options.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// 7.2節: レートリミット超過時のエラーハンドリングと
/// 指数バックオフによる自動リトライの動作確認用サンプルです。
/// コンソールでレートリミットの値を小さく設定すると再現できます。
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.5-flash-lite',
  );

  try {
    final response = await generateWithRetry(model, [
      Content.text('魔法のバックパックについての物語を書いてください。'),
    ]);
    debugPrint(response.text);
  } on QuotaExceeded catch (e) {
    // リトライしても解消しなかった場合のRate Limit超過時の処理
    debugPrint('レートリミットを超過しました: ${e.message}');
  }
}

/// リトライのたびに待機時間を延ばす指数バックオフ（Exponential Backoff）で
/// 自動リトライしながらテキストを生成します。
Future<GenerateContentResponse> generateWithRetry(
  GenerativeModel model,
  List<Content> content, {
  int maxRetries = 3,
}) async {
  var retryCount = 0;
  var delayMs = 1000; // 初期待機時間: 1秒

  while (true) {
    try {
      return await model.generateContent(content);
    } on QuotaExceeded {
      if (retryCount < maxRetries) {
        retryCount++;
        await Future<void>.delayed(Duration(milliseconds: delayMs));
        delayMs *= 2; // 待機時間を倍増（1秒 → 2秒 → 4秒）
      } else {
        rethrow;
      }
    }
  }
}
