import 'package:flutter/material.dart';

/// デバッグページ用のアイコンコンテナ
///
/// 角丸の背景にアイコンを表示する共通コンポーネント。
class DebugIconContainer extends StatelessWidget {
  const DebugIconContainer({
    super.key,
    required this.icon,
    this.isActive = true,
  });

  /// 表示するアイコン
  final IconData icon;

  /// アクティブ状態かどうか（色の切り替えに使用）
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const .all(8),
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primaryContainer.withValues(alpha: 0.5)
            : colorScheme.surfaceContainerHighest,
        borderRadius: .circular(8),
      ),
      child: Icon(
        icon,
        size: 20,
        color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// デバッグページ用のListTile
///
/// アイコンコンテナとシェブロンアイコンを含むスタイル付きListTile。
class DebugListTile extends StatelessWidget {
  const DebugListTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.isActive = true,
  });

  /// 先頭に表示するアイコン
  final IconData icon;

  /// タイトルテキスト
  final String title;

  /// タップ時のコールバック
  final VoidCallback? onTap;

  /// 末尾に表示するウィジェット（指定しない場合はシェブロンアイコン）
  final Widget? trailing;

  /// アクティブ状態かどうか
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: DebugIconContainer(
        icon: icon,
        isActive: isActive,
      ),
      title: Text(title),
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurfaceVariant,
          ),
      onTap: onTap,
    );
  }
}

/// デバッグページ用の情報表示ListTile
///
/// ラベルと値を表示するための読み取り専用タイル。
class DebugInfoTile extends StatelessWidget {
  const DebugInfoTile({
    super.key,
    required this.icon,
    required this.label,
    this.value,
  });

  /// 先頭に表示するアイコン
  final IconData icon;

  /// ラベルテキスト
  final String label;

  /// 値テキスト（nullの場合は '---' を表示）
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: DebugIconContainer(icon: icon),
      title: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Text(
        value ?? '---',
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: .w500,
        ),
      ),
    );
  }
}
