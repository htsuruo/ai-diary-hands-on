import 'package:firebase_ai/firebase_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'; // ①

part 'firebase_ai_provider.g.dart'; // ②

@Riverpod(keepAlive: true) // ③
FirebaseAI firebaseAI(Ref ref) => FirebaseAI.vertexAI(location: 'global'); // ④
