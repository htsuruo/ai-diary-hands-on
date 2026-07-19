import 'package:firebase_ai/firebase_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_ai_provider.g.dart';

@Riverpod(keepAlive: true)
FirebaseAI firebaseAI(Ref ref) => FirebaseAI.googleAI();

// Vertex AI Gemini APIを利用する場合
// FirebaseAI firebaseAI(Ref ref) => FirebaseAI.vertexAI(location: 'global');
