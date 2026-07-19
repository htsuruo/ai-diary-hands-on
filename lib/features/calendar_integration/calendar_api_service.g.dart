// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'calendar_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(calendarApiService)
const calendarApiServiceProvider = CalendarApiServiceProvider._();

final class CalendarApiServiceProvider
    extends
        $FunctionalProvider<
          CalendarApiService,
          CalendarApiService,
          CalendarApiService
        >
    with $Provider<CalendarApiService> {
  const CalendarApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarApiServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarApiServiceHash();

  @$internal
  @override
  $ProviderElement<CalendarApiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CalendarApiService create(Ref ref) {
    return calendarApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalendarApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalendarApiService>(value),
    );
  }
}

String _$calendarApiServiceHash() =>
    r'72a6adce2c1f8acc19e6afe9088e75be71d89b92';
