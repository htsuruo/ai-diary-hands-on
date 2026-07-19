// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sentiment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SentimentState {

 Sentiment get sentiment;// ①
 String get reason;
/// Create a copy of SentimentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SentimentStateCopyWith<SentimentState> get copyWith => _$SentimentStateCopyWithImpl<SentimentState>(this as SentimentState, _$identity);

  /// Serializes this SentimentState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SentimentState&&(identical(other.sentiment, sentiment) || other.sentiment == sentiment)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sentiment,reason);

@override
String toString() {
  return 'SentimentState(sentiment: $sentiment, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $SentimentStateCopyWith<$Res>  {
  factory $SentimentStateCopyWith(SentimentState value, $Res Function(SentimentState) _then) = _$SentimentStateCopyWithImpl;
@useResult
$Res call({
 Sentiment sentiment, String reason
});




}
/// @nodoc
class _$SentimentStateCopyWithImpl<$Res>
    implements $SentimentStateCopyWith<$Res> {
  _$SentimentStateCopyWithImpl(this._self, this._then);

  final SentimentState _self;
  final $Res Function(SentimentState) _then;

/// Create a copy of SentimentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sentiment = null,Object? reason = null,}) {
  return _then(_self.copyWith(
sentiment: null == sentiment ? _self.sentiment : sentiment // ignore: cast_nullable_to_non_nullable
as Sentiment,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SentimentState].
extension SentimentStatePatterns on SentimentState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SentimentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SentimentState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SentimentState value)  $default,){
final _that = this;
switch (_that) {
case _SentimentState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SentimentState value)?  $default,){
final _that = this;
switch (_that) {
case _SentimentState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Sentiment sentiment,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SentimentState() when $default != null:
return $default(_that.sentiment,_that.reason);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Sentiment sentiment,  String reason)  $default,) {final _that = this;
switch (_that) {
case _SentimentState():
return $default(_that.sentiment,_that.reason);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Sentiment sentiment,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _SentimentState() when $default != null:
return $default(_that.sentiment,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SentimentState extends SentimentState {
  const _SentimentState({required this.sentiment, required this.reason}): super._();
  factory _SentimentState.fromJson(Map<String, dynamic> json) => _$SentimentStateFromJson(json);

@override final  Sentiment sentiment;
// ①
@override final  String reason;

/// Create a copy of SentimentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SentimentStateCopyWith<_SentimentState> get copyWith => __$SentimentStateCopyWithImpl<_SentimentState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SentimentStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SentimentState&&(identical(other.sentiment, sentiment) || other.sentiment == sentiment)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sentiment,reason);

@override
String toString() {
  return 'SentimentState(sentiment: $sentiment, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$SentimentStateCopyWith<$Res> implements $SentimentStateCopyWith<$Res> {
  factory _$SentimentStateCopyWith(_SentimentState value, $Res Function(_SentimentState) _then) = __$SentimentStateCopyWithImpl;
@override @useResult
$Res call({
 Sentiment sentiment, String reason
});




}
/// @nodoc
class __$SentimentStateCopyWithImpl<$Res>
    implements _$SentimentStateCopyWith<$Res> {
  __$SentimentStateCopyWithImpl(this._self, this._then);

  final _SentimentState _self;
  final $Res Function(_SentimentState) _then;

/// Create a copy of SentimentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sentiment = null,Object? reason = null,}) {
  return _then(_SentimentState(
sentiment: null == sentiment ? _self.sentiment : sentiment // ignore: cast_nullable_to_non_nullable
as Sentiment,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
