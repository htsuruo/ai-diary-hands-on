import 'dart:async';

import 'package:ai_diary_hands_on/features/calendar_integration/calendar_ai_assistant.dart';
import 'package:ai_diary_hands_on/features/calendar_integration/calendar_event.dart';
import 'package:ai_diary_hands_on/features/calendar_integration/event_created_dialog.dart';
import 'package:ai_diary_hands_on/features/diary/ui/edit/view_models/diary_form_view_model.dart';
import 'package:ai_diary_hands_on/features/diary/ui/edit/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tsuruo_kit/tsuruo_kit.dart';

import '../../diary.dart';
import 'view_models/form_validator.dart';
import 'widgets/content_form_field.dart';
import 'widgets/date_form_field.dart';
import 'widgets/title_form_field.dart';

class DiaryEditPage extends ConsumerStatefulWidget {
  const DiaryEditPage({super.key, this.diaryId});

  final String? diaryId;

  @override
  ConsumerState<DiaryEditPage> createState() => _DiaryEditPageState();
}

class _DiaryEditPageState extends ConsumerState<DiaryEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController();
  late final _contentController = TextEditingController();
  // 選択中の日付（yyyy-MM-dd形式）。初期値は読み込んだ日記の日付
  late final _dateNotifier = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _dateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
    final diary = ref.watch(diaryFormViewModelProvider(widget.diaryId)).value;

    if (diary == null) {
      return const EmptyScreen();
    }

    _titleController.text = diary.title;
    _contentController.text = diary.content;
    _dateNotifier.value ??= diary.date;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const .only(right: 8),
            child: _SubmitButton(
              formKey: _formKey,
              titleController: _titleController,
              contentController: _contentController,
              dateNotifier: _dateNotifier,
              diary: diary,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Gap(8),
              // 日付選択（デフォルトは当日）
              Padding(
                padding: padding,
                child: DateFormField(dateNotifier: _dateNotifier),
              ),
              Padding(
                padding: padding,
                child: TitleFormField(titleController: _titleController),
              ),
              const Gap(4),
              Expanded(
                child: Padding(
                  padding: padding,
                  child: ContentFormField(
                    contentController: _contentController,
                  ),
                ),
              ),
              const Gap(8),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends ConsumerWidget {
  const _SubmitButton({
    required this.formKey,
    required this.titleController,
    required this.contentController,
    required this.dateNotifier,
    required this.diary,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final ValueNotifier<String?> dateNotifier;
  final DiaryEntry diary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 保存処理
    Future<void> onSubmit() async {
      if (!formKey.currentState!.validate()) {
        return;
      }

      final isNew = diary.id.isEmpty;
      final title = titleController.text;
      final content = contentController.text;
      final date = dateNotifier.value ?? diary.date;
      final newDiary = diary.copyWith(
        title: title,
        content: content,
        date: date,
      );

      final event = await ref
          .read(progressProvider.notifier)
          .runWithProgress<CalendarEvent?>(() async {
            // 日記を保存
            await ref
                .read(diaryFormViewModelProvider(diary.id).notifier)
                .save(newDiary);

            if (isNew) {
              final event = await ref
                  .read(calendarAiAssistantProvider)
                  .createEventIfNeeded(content: content);
              return event;
            }
            return null;
          });

      if (event != null) {
        await showEventCreatedDialog(context: context, event: event);
      }

      // 保存完了メッセージを表示
      ref
          .read(scaffoldMessengerKeyProvider)
          .currentState
          ?.showMessage(
            '日記を${isNew ? '作成' : '更新'}しました。',
          );

      // 画面を閉じる
      if (context.mounted) {
        context.pop();
      }
    }

    return ListenableBuilder(
      listenable: Listenable.merge([titleController, contentController]),
      builder: (context, _) {
        final titleError = FormValidator.validateTitle(titleController.text);
        final contentError = FormValidator.validateContent(
          contentController.text,
        );
        final isFormValid = titleError == null && contentError == null;

        return FilledButton.tonal(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontWeight: .w600),
          ),
          onPressed: isFormValid ? onSubmit : null,
          child: const Text('保存する'),
        );
      },
    );
  }
}
