// 第6章で CalendarEvent を作成した後、以下のコメントアウトを解除します。
//
// import 'package:ai_diary_hands_on/features/calendar_integration/calendar_event.dart';
// import 'package:ai_diary_hands_on/shared/extensions/date_time.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
//
// /// Googleカレンダーにイベントが追加されたことを通知するダイアログを表示します。
// Future<void> showEventCreatedDialog({
//   required BuildContext context,
//   required CalendarEvent event,
// }) {
//   return showDialog<void>(
//     context: context,
//     builder: (context) => _EventCreatedDialog(event: event),
//   );
// }
//
// class _EventCreatedDialog extends StatelessWidget {
//   const _EventCreatedDialog({required this.event});
//
//   final CalendarEvent event;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: .circular(20)),
//       child: Padding(
//         padding: const .all(24),
//         child: Column(
//           mainAxisSize: .min,
//           children: [
//             Container(
//               padding: const .all(16),
//               decoration: BoxDecoration(
//                 color: colorScheme.primaryContainer,
//                 shape: .circle,
//               ),
//               child: Icon(
//                 Icons.check,
//                 color: colorScheme.onPrimaryContainer,
//               ),
//             ),
//             const Gap(16),
//             Text(
//               'Googleカレンダーに\n以下の予定を追加しました',
//               textAlign: .center,
//               style: theme.textTheme.titleMedium?.copyWith(
//                 fontWeight: .bold,
//                 fontSize: 18,
//               ),
//             ),
//             const Gap(20),
//             Container(
//               width: double.infinity,
//               padding: const .all(16),
//               decoration: BoxDecoration(
//                 color: colorScheme.surfaceContainer,
//                 borderRadius: .circular(12),
//                 border: Border.all(color: colorScheme.outlineVariant),
//               ),
//               child: Column(
//                 crossAxisAlignment: .start,
//                 children: [
//                   _EventDetailRow(
//                     icon: Icons.title,
//                     label: '件名',
//                     value: event.title,
//                   ),
//                   const Gap(12),
//                   _EventDetailRow(
//                     icon: Icons.description_outlined,
//                     label: '詳細',
//                     value: event.description,
//                   ),
//                   const Gap(12),
//                   _EventDetailRow(
//                     icon: Icons.schedule,
//                     label: '開始',
//                     value: event.startTime.formatted,
//                   ),
//                   const Gap(12),
//                   _EventDetailRow(
//                     icon: Icons.schedule_outlined,
//                     label: '終了',
//                     value: event.endTime?.formatted ?? '未設定',
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Icon(
//                   Icons.info_outline,
//                   size: 16,
//                   color: colorScheme.onSurfaceVariant,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     '詳細はGoogleカレンダーアプリで確認できます',
//                     style: theme.textTheme.bodySmall?.copyWith(
//                       color: colorScheme.onSurfaceVariant,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: FilledButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('OK'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _EventDetailRow extends StatelessWidget {
//   const _EventDetailRow({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });
//
//   final IconData icon;
//   final String label;
//   final String value;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//
//     return Row(
//       crossAxisAlignment: .start,
//       children: [
//         Icon(icon, size: 18, color: colorScheme.primary),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: .start,
//             children: [
//               Text(
//                 label,
//                 style: theme.textTheme.labelSmall?.copyWith(
//                   color: colorScheme.onSurfaceVariant,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(value, style: theme.textTheme.bodyMedium),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
