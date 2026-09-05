import 'package:flutter/material.dart';

import 'sentiment.dart';

extension SentimentUiExtension on Sentiment {
  Color get color => switch (this) {
    Sentiment.positive => Colors.green,
    Sentiment.negative => Colors.redAccent,
    Sentiment.neutral => Colors.grey,
  };

  Color get backgroundColor => color.withValues(alpha: 0.1);

  IconData get icon => switch (this) {
    Sentiment.positive => Icons.sentiment_satisfied_alt,
    Sentiment.negative => Icons.sentiment_very_dissatisfied,
    Sentiment.neutral => Icons.sentiment_neutral,
  };
}
