import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.1-flash-lite',
  );

  final prompt = [
    Content.text('魔法のバックパックについての物語を書いてください。'),
  ];

  final response = await model.generateContent(prompt);
  debugPrint(response.text);
}
