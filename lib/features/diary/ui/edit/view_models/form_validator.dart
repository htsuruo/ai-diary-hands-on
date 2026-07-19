class FormValidator {
  FormValidator._();

  static const titleMaxLength = 30;
  static const contentMaxLength = 1000;

  static String? validateTitle(String? value) {
    final emptyText = _validateNotEmptyText(value);
    if (emptyText != null) {
      return emptyText;
    }
    if (value!.length > titleMaxLength) {
      return '$titleMaxLength文字以内で入力しましょう';
    }
    return null;
  }

  static String? validateContent(String? value) {
    final emptyText = _validateNotEmptyText(value);
    if (emptyText != null) {
      return emptyText;
    }
    if (value!.length > contentMaxLength) {
      return '$contentMaxLength文字以内で入力しましょう';
    }
    return null;
  }

  static String? _validateNotEmptyText(String? value) {
    if (value!.isEmpty) {
      return 'テキストを入力しましょう';
    }
    return null;
  }
}
