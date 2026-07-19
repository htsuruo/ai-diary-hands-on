import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'calendar_event.dart';
import 'google_auth_provider.dart';

part 'calendar_api_service.g.dart';

@Riverpod(keepAlive: true) // ①
CalendarApiService calendarApiService(Ref ref) => CalendarApiService(ref);

class CalendarApiService {
  CalendarApiService(this._ref);
  final Ref _ref;

  Future<void> addEvent(CalendarEvent event) async {
    final accessToken = await _ref.read(
      googleUserAccessTokenProvider.future,
    ); // ②
    if (accessToken == null) {
      return;
    }
    final authorization = GoogleSignInClientAuthorization(
      // ③
      accessToken: accessToken,
    );
    final client = authorization.authClient(
      scopes: [
        // ④
        CalendarApi.calendarEventsOwnedScope,
      ],
    );
    final calendarApi = CalendarApi(client); // ⑤
    await calendarApi.events.insert(
      // ⑥
      Event(
        summary: event.title,
        description: event.description,
        start: EventDateTime(dateTime: event.startTime),
        end: EventDateTime(dateTime: event.endTime ?? event.startTime),
      ),
      'primary',
    );
  }
}
