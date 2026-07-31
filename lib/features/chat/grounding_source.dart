import 'package:freezed_annotation/freezed_annotation.dart';

part 'grounding_source.freezed.dart';

@freezed
abstract class GroundingSource with _$GroundingSource {
  const factory GroundingSource({
    required String uri,
    required String title,
  }) = _GroundingSource;
}
