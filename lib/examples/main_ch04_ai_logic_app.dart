import 'package:firebase_ai/firebase_ai.dart'; // ①
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MainApp(),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final Future<GenerateContentResponse> _future;

  @override
  void initState() {
    super.initState();
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.1-flash-lite',
    );

    final prompt = [
      Content.text('魔法のバックパックについての物語を書いてください。'),
    ];
    _future = model.generateContent(prompt);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase AI Logic Example'),
        ),
        body: FutureBuilder<GenerateContentResponse>(
          future: _future,
          builder: (_, snapshot) {
            if (snapshot.connectionState == .waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final text = snapshot.data?.candidates.first.text ?? '';
            debugPrint(text);
            return SingleChildScrollView(
              padding: const .all(16),
              child: Text(text),
            );
          },
        ),
      ),
    );
  }
}
