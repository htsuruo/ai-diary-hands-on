import 'package:ai_diary_hands_on/core/core.dart';
import 'package:ai_diary_hands_on/shared/shared.dart';
import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: EmptyWidget(
          icon: Icons.search_off,
          title: '日記が見つかりません',
          message: 'この日記は削除されたか、\n存在しない可能性があります',
          action: EmptyAction(
            label: 'ホームに戻る',
            iconData: Icons.home,
            onPressed: () => const DiariesPageRoute().go(context),
          ),
        ),
      ),
    );
  }
}
