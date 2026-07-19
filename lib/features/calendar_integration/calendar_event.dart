import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_event.freezed.dart';
part 'calendar_event.g.dart';

@freezed
abstract class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    // ①
    required String title,
    required String description,
    required DateTime startTime,
    DateTime? endTime,
  }) = _CalendarEvent;

  factory CalendarEvent.fromJson(Map<String, dynamic> json) => // ②
      _$CalendarEventFromJson(json);
  const CalendarEvent._();
}
