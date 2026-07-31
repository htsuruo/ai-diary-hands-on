import 'package:flutter/material.dart';

import 'ai_logic_minimal.dart';

class AiLogicTutorialApp extends StatefulWidget {
  const AiLogicTutorialApp({super.key});

  @override
  State<AiLogicTutorialApp> createState() => _AiLogicTutorialAppState();
}

class _AiLogicTutorialAppState extends State<AiLogicTutorialApp> {
  late final Future<String?> _future;

  @override
  void initState() {
    super.initState();
    _future = generateText();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase AI Logic Example'),
        ),
        body: FutureBuilder<String?>(
          future: _future,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final text = snapshot.data ?? '';
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                text,
                locale: const Locale('ja'),
              ),
            );
          },
        ),
      ),
    );
  }
}
