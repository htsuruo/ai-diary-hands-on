// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'calendar_ai_assistant.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(calendarAiAssistant)
const calendarAiAssistantProvider = CalendarAiAssistantProvider._();

final class CalendarAiAssistantProvider
    extends
        $FunctionalProvider<
          CalendarAiAssistant,
          CalendarAiAssistant,
          CalendarAiAssistant
        >
    with $Provider<CalendarAiAssistant> {
  const CalendarAiAssistantProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarAiAssistantProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarAiAssistantHash();

  @$internal
  @override
  $ProviderElement<CalendarAiAssistant> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CalendarAiAssistant create(Ref ref) {
    return calendarAiAssistant(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalendarAiAssistant value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalendarAiAssistant>(value),
    );
  }
}

String _$calendarAiAssistantHash() =>
    r'e5c35678858e5656f414855f6c630406d90958fb';
