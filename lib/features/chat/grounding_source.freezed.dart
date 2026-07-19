// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grounding_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroundingSource {

 String get uri; String get title;
/// Create a copy of GroundingSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroundingSourceCopyWith<GroundingSource> get copyWith => _$GroundingSourceCopyWithImpl<GroundingSource>(this as GroundingSource, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroundingSource&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,uri,title);

@override
String toString() {
  return 'GroundingSource(uri: $uri, title: $title)';
}


}

/// @nodoc
abstract mixin class $GroundingSourceCopyWith<$Res>  {
  factory $GroundingSourceCopyWith(GroundingSource value, $Res Function(GroundingSource) _then) = _$GroundingSourceCopyWithImpl;
@useResult
$Res call({
 String uri, String title
});




}
/// @nodoc
class _$GroundingSourceCopyWithImpl<$Res>
    implements $GroundingSourceCopyWith<$Res> {
  _$GroundingSourceCopyWithImpl(this._self, this._then);

  final GroundingSource _self;
  final $Res Function(GroundingSource) _then;

/// Create a copy of GroundingSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uri = null,Object? title = null,}) {
  return _then(_self.copyWith(
uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GroundingSource].
extension GroundingSourcePatterns on GroundingSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroundingSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroundingSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroundingSource value)  $default,){
final _that = this;
switch (_that) {
case _GroundingSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroundingSource value)?  $default,){
final _that = this;
switch (_that) {
case _GroundingSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uri,  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroundingSource() when $default != null:
return $default(_that.uri,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uri,  String title)  $default,) {final _that = this;
switch (_that) {
case _GroundingSource():
return $default(_that.uri,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uri,  String title)?  $default,) {final _that = this;
switch (_that) {
case _GroundingSource() when $default != null:
return $default(_that.uri,_that.title);case _:
  return null;

}
}

}

/// @nodoc


class _GroundingSource implements GroundingSource {
  const _GroundingSource({required this.uri, required this.title});
  

@override final  String uri;
@override final  String title;

/// Create a copy of GroundingSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroundingSourceCopyWith<_GroundingSource> get copyWith => __$GroundingSourceCopyWithImpl<_GroundingSource>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroundingSource&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,uri,title);

@override
String toString() {
  return 'GroundingSource(uri: $uri, title: $title)';
}


}

/// @nodoc
abstract mixin class _$GroundingSourceCopyWith<$Res> implements $GroundingSourceCopyWith<$Res> {
  factory _$GroundingSourceCopyWith(_GroundingSource value, $Res Function(_GroundingSource) _then) = __$GroundingSourceCopyWithImpl;
@override @useResult
$Res call({
 String uri, String title
});




}
/// @nodoc
class __$GroundingSourceCopyWithImpl<$Res>
    implements _$GroundingSourceCopyWith<$Res> {
  __$GroundingSourceCopyWithImpl(this._self, this._then);

  final _GroundingSource _self;
  final $Res Function(_GroundingSource) _then;

/// Create a copy of GroundingSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uri = null,Object? title = null,}) {
  return _then(_GroundingSource(
uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
