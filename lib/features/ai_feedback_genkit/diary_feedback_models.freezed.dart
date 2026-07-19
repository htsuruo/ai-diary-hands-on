// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary_feedback_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiaryFeedbackInput {

 String get content;
/// Create a copy of DiaryFeedbackInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryFeedbackInputCopyWith<DiaryFeedbackInput> get copyWith => _$DiaryFeedbackInputCopyWithImpl<DiaryFeedbackInput>(this as DiaryFeedbackInput, _$identity);

  /// Serializes this DiaryFeedbackInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryFeedbackInput&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content);

@override
String toString() {
  return 'DiaryFeedbackInput(content: $content)';
}


}

/// @nodoc
abstract mixin class $DiaryFeedbackInputCopyWith<$Res>  {
  factory $DiaryFeedbackInputCopyWith(DiaryFeedbackInput value, $Res Function(DiaryFeedbackInput) _then) = _$DiaryFeedbackInputCopyWithImpl;
@useResult
$Res call({
 String content
});




}
/// @nodoc
class _$DiaryFeedbackInputCopyWithImpl<$Res>
    implements $DiaryFeedbackInputCopyWith<$Res> {
  _$DiaryFeedbackInputCopyWithImpl(this._self, this._then);

  final DiaryFeedbackInput _self;
  final $Res Function(DiaryFeedbackInput) _then;

/// Create a copy of DiaryFeedbackInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryFeedbackInput].
extension DiaryFeedbackInputPatterns on DiaryFeedbackInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryFeedbackInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryFeedbackInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryFeedbackInput value)  $default,){
final _that = this;
switch (_that) {
case _DiaryFeedbackInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryFeedbackInput value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryFeedbackInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryFeedbackInput() when $default != null:
return $default(_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content)  $default,) {final _that = this;
switch (_that) {
case _DiaryFeedbackInput():
return $default(_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content)?  $default,) {final _that = this;
switch (_that) {
case _DiaryFeedbackInput() when $default != null:
return $default(_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryFeedbackInput implements DiaryFeedbackInput {
  const _DiaryFeedbackInput({required this.content});
  factory _DiaryFeedbackInput.fromJson(Map<String, dynamic> json) => _$DiaryFeedbackInputFromJson(json);

@override final  String content;

/// Create a copy of DiaryFeedbackInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryFeedbackInputCopyWith<_DiaryFeedbackInput> get copyWith => __$DiaryFeedbackInputCopyWithImpl<_DiaryFeedbackInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryFeedbackInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryFeedbackInput&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content);

@override
String toString() {
  return 'DiaryFeedbackInput(content: $content)';
}


}

/// @nodoc
abstract mixin class _$DiaryFeedbackInputCopyWith<$Res> implements $DiaryFeedbackInputCopyWith<$Res> {
  factory _$DiaryFeedbackInputCopyWith(_DiaryFeedbackInput value, $Res Function(_DiaryFeedbackInput) _then) = __$DiaryFeedbackInputCopyWithImpl;
@override @useResult
$Res call({
 String content
});




}
/// @nodoc
class __$DiaryFeedbackInputCopyWithImpl<$Res>
    implements _$DiaryFeedbackInputCopyWith<$Res> {
  __$DiaryFeedbackInputCopyWithImpl(this._self, this._then);

  final _DiaryFeedbackInput _self;
  final $Res Function(_DiaryFeedbackInput) _then;

/// Create a copy of DiaryFeedbackInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,}) {
  return _then(_DiaryFeedbackInput(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DiaryFeedbackOutput {

 String get feedback;// ②
 Sentiment get sentiment;// ③
 bool get isComplete;
/// Create a copy of DiaryFeedbackOutput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryFeedbackOutputCopyWith<DiaryFeedbackOutput> get copyWith => _$DiaryFeedbackOutputCopyWithImpl<DiaryFeedbackOutput>(this as DiaryFeedbackOutput, _$identity);

  /// Serializes this DiaryFeedbackOutput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryFeedbackOutput&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.sentiment, sentiment) || other.sentiment == sentiment)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,feedback,sentiment,isComplete);

@override
String toString() {
  return 'DiaryFeedbackOutput(feedback: $feedback, sentiment: $sentiment, isComplete: $isComplete)';
}


}

/// @nodoc
abstract mixin class $DiaryFeedbackOutputCopyWith<$Res>  {
  factory $DiaryFeedbackOutputCopyWith(DiaryFeedbackOutput value, $Res Function(DiaryFeedbackOutput) _then) = _$DiaryFeedbackOutputCopyWithImpl;
@useResult
$Res call({
 String feedback, Sentiment sentiment, bool isComplete
});




}
/// @nodoc
class _$DiaryFeedbackOutputCopyWithImpl<$Res>
    implements $DiaryFeedbackOutputCopyWith<$Res> {
  _$DiaryFeedbackOutputCopyWithImpl(this._self, this._then);

  final DiaryFeedbackOutput _self;
  final $Res Function(DiaryFeedbackOutput) _then;

/// Create a copy of DiaryFeedbackOutput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? feedback = null,Object? sentiment = null,Object? isComplete = null,}) {
  return _then(_self.copyWith(
feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String,sentiment: null == sentiment ? _self.sentiment : sentiment // ignore: cast_nullable_to_non_nullable
as Sentiment,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryFeedbackOutput].
extension DiaryFeedbackOutputPatterns on DiaryFeedbackOutput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryFeedbackOutput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryFeedbackOutput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryFeedbackOutput value)  $default,){
final _that = this;
switch (_that) {
case _DiaryFeedbackOutput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryFeedbackOutput value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryFeedbackOutput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String feedback,  Sentiment sentiment,  bool isComplete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryFeedbackOutput() when $default != null:
return $default(_that.feedback,_that.sentiment,_that.isComplete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String feedback,  Sentiment sentiment,  bool isComplete)  $default,) {final _that = this;
switch (_that) {
case _DiaryFeedbackOutput():
return $default(_that.feedback,_that.sentiment,_that.isComplete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String feedback,  Sentiment sentiment,  bool isComplete)?  $default,) {final _that = this;
switch (_that) {
case _DiaryFeedbackOutput() when $default != null:
return $default(_that.feedback,_that.sentiment,_that.isComplete);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryFeedbackOutput implements DiaryFeedbackOutput {
  const _DiaryFeedbackOutput({required this.feedback, this.sentiment = Sentiment.neutral, this.isComplete = false});
  factory _DiaryFeedbackOutput.fromJson(Map<String, dynamic> json) => _$DiaryFeedbackOutputFromJson(json);

@override final  String feedback;
// ②
@override@JsonKey() final  Sentiment sentiment;
// ③
@override@JsonKey() final  bool isComplete;

/// Create a copy of DiaryFeedbackOutput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryFeedbackOutputCopyWith<_DiaryFeedbackOutput> get copyWith => __$DiaryFeedbackOutputCopyWithImpl<_DiaryFeedbackOutput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryFeedbackOutputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryFeedbackOutput&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.sentiment, sentiment) || other.sentiment == sentiment)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,feedback,sentiment,isComplete);

@override
String toString() {
  return 'DiaryFeedbackOutput(feedback: $feedback, sentiment: $sentiment, isComplete: $isComplete)';
}


}

/// @nodoc
abstract mixin class _$DiaryFeedbackOutputCopyWith<$Res> implements $DiaryFeedbackOutputCopyWith<$Res> {
  factory _$DiaryFeedbackOutputCopyWith(_DiaryFeedbackOutput value, $Res Function(_DiaryFeedbackOutput) _then) = __$DiaryFeedbackOutputCopyWithImpl;
@override @useResult
$Res call({
 String feedback, Sentiment sentiment, bool isComplete
});




}
/// @nodoc
class __$DiaryFeedbackOutputCopyWithImpl<$Res>
    implements _$DiaryFeedbackOutputCopyWith<$Res> {
  __$DiaryFeedbackOutputCopyWithImpl(this._self, this._then);

  final _DiaryFeedbackOutput _self;
  final $Res Function(_DiaryFeedbackOutput) _then;

/// Create a copy of DiaryFeedbackOutput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? feedback = null,Object? sentiment = null,Object? isComplete = null,}) {
  return _then(_DiaryFeedbackOutput(
feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String,sentiment: null == sentiment ? _self.sentiment : sentiment // ignore: cast_nullable_to_non_nullable
as Sentiment,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
