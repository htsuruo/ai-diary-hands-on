import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// デバッグページ用のセクションウィジェット
///
/// ヘッダーとコンテンツ（ListTile群）をまとめて表示する。
class DebugSection extends StatelessWidget {
  const DebugSection({
    super.key,
    required this.title,
    required this.children,
  });

  /// セクションのタイトル
  final String title;

  /// セクション内のコンテンツ（通常はListTile群）
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const .only(left: 4, bottom: 8),
            child: Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: .w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: .circular(16),
              side: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            clipBehavior: .antiAlias,
            child: Column(
              children: _buildChildrenWithDividers(context),
            ),
          ),
          const Gap(16),
        ],
      ),
    );
  }

  List<Widget> _buildChildrenWithDividers(BuildContext context) {
    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(
          Divider(
            height: 1,
            indent: 56,
            color: Theme.of(context).colorScheme.outlineVariant.withValues(
              alpha: 0.5,
            ),
          ),
        );
      }
    }
    return result;
  }
}
