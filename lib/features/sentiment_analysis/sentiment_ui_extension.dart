import 'package:flutter/material.dart';

import 'sentiment.dart';

// ダークテーマ対応する場合はThemeExtensionにすることも検討
extension SentimentUiExtension on Sentiment {
  Color get color => switch (this) {
    .positive => Colors.green,
    .negative => Colors.redAccent,
    .neutral => Colors.grey,
  };

  Color get backgroundColor => color.withValues(alpha: 0.1);

  IconData get icon => switch (this) {
    .positive => Icons.sentiment_satisfied_alt,
    .negative => Icons.sentiment_very_dissatisfied,
    .neutral => Icons.sentiment_neutral,
  };
}
