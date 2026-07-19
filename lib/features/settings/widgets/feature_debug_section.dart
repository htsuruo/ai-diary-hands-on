import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'debug_section.dart';

/// 各章で実装する機能の動作確認に使用するセクションです。
class FeatureDebugSection extends ConsumerWidget {
  const FeatureDebugSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DebugSection(
      title: '機能実装デバッグ',
      children: [],
    );
  }
}
