enum Sentiment {
  positive('ポジティブ'),
  negative('ネガティブ'),
  neutral('ニュートラル'),
  ;

  const Sentiment(this.label);
  final String label;
}
