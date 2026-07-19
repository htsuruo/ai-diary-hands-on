import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// 空状態を表示する汎用ウィジェット
///
/// リストが空、データが見つからない、検索結果なしなどの
/// 空状態を統一的に表示するためのウィジェット。
///
/// 使用例:
/// ```dart
/// // フルスクリーン表示
/// Scaffold(
///   body: Center(
///     child: EmptyWidget(
///       icon: Icons.search_off,
///       title: '日記が見つかりません',
///       message: 'この日記は削除されたか、\n存在しない可能性があります',
///       action: EmptyAction(
///         label: 'ホームに戻る',
///         icon: Icons.home,
///         onPressed: () => context.go('/'),
///       ),
///     ),
///   ),
/// )
///
/// // シンプルな表示（メッセージとボタンなし）
/// EmptyWidget(
///   icon: Icons.inbox,
///   title: 'まだデータがありません',
/// )
/// ```
class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    required this.icon,
    required this.title,
    this.message,
    this.action,
    this.isError = false,
    super.key,
  });

  const EmptyWidget.error({
    required this.title,
    this.message,
    this.action,
    super.key,
  }) : icon = Icons.error_outline,
       isError = true;

  /// 表示するアイコン
  final IconData icon;

  /// メインタイトル
  final String title;

  /// 補足メッセージ（オプション）
  final String? message;

  /// アクションボタン（オプション）
  final EmptyAction? action;

  /// エラー状態かどうか
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final emptyColor = colorScheme.onSurface;
    final message = this.message;
    final action = this.action;

    // エラー時はcolorScheme.errorを使用、それ以外はiconColorまたはデフォルト色
    final effectiveIconColor = isError
        ? colorScheme.error
        : emptyColor.withValues(alpha: 0.3);

    return Column(
      mainAxisSize: .min,
      mainAxisAlignment: .center,
      children: [
        Icon(
          icon,
          size: 64,
          color: effectiveIconColor,
        ),
        const Gap(16),
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            color: emptyColor.withValues(alpha: 0.6),
          ),
          textAlign: .center,
        ),
        if (message != null) ...[
          const Gap(16),
          Text(
            message,
            textAlign: .center,
            style: textTheme.bodyMedium?.copyWith(
              color: emptyColor.withValues(alpha: 0.5),
            ),
          ),
        ],
        if (action != null) ...[
          const Gap(24),
          FilledButton.icon(
            onPressed: action.onPressed,
            icon: Icon(action.iconData),
            label: Text(action.label),
          ),
        ],
      ],
    );
  }
}

/// EmptyWidget のアクションボタン設定
class EmptyAction {
  const EmptyAction({
    required this.label,
    required this.onPressed,
    required this.iconData,
  });

  /// ボタンのラベル
  final String label;

  /// ボタン押下時の処理
  final VoidCallback onPressed;

  /// ボタンのアイコン（オプション）
  final IconData iconData;
}
