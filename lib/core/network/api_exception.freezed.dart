// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiException {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiException()';
}


}

/// @nodoc
class $ApiExceptionCopyWith<$Res>  {
$ApiExceptionCopyWith(ApiException _, $Res Function(ApiException) __);
}


/// Adds pattern-matching-related methods to [ApiException].
extension ApiExceptionPatterns on ApiException {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NetworkException value)?  network,TResult Function( UnauthorizedException value)?  unauthorized,TResult Function( ForbiddenException value)?  forbidden,TResult Function( NotFoundException value)?  notFound,TResult Function( ServerException value)?  server,TResult Function( UnknownApiException value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NetworkException() when network != null:
return network(_that);case UnauthorizedException() when unauthorized != null:
return unauthorized(_that);case ForbiddenException() when forbidden != null:
return forbidden(_that);case NotFoundException() when notFound != null:
return notFound(_that);case ServerException() when server != null:
return server(_that);case UnknownApiException() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NetworkException value)  network,required TResult Function( UnauthorizedException value)  unauthorized,required TResult Function( ForbiddenException value)  forbidden,required TResult Function( NotFoundException value)  notFound,required TResult Function( ServerException value)  server,required TResult Function( UnknownApiException value)  unknown,}){
final _that = this;
switch (_that) {
case NetworkException():
return network(_that);case UnauthorizedException():
return unauthorized(_that);case ForbiddenException():
return forbidden(_that);case NotFoundException():
return notFound(_that);case ServerException():
return server(_that);case UnknownApiException():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NetworkException value)?  network,TResult? Function( UnauthorizedException value)?  unauthorized,TResult? Function( ForbiddenException value)?  forbidden,TResult? Function( NotFoundException value)?  notFound,TResult? Function( ServerException value)?  server,TResult? Function( UnknownApiException value)?  unknown,}){
final _that = this;
switch (_that) {
case NetworkException() when network != null:
return network(_that);case UnauthorizedException() when unauthorized != null:
return unauthorized(_that);case ForbiddenException() when forbidden != null:
return forbidden(_that);case NotFoundException() when notFound != null:
return notFound(_that);case ServerException() when server != null:
return server(_that);case UnknownApiException() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message)?  network,TResult Function()?  unauthorized,TResult Function()?  forbidden,TResult Function()?  notFound,TResult Function( String message)?  server,TResult Function( String message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NetworkException() when network != null:
return network(_that.message);case UnauthorizedException() when unauthorized != null:
return unauthorized();case ForbiddenException() when forbidden != null:
return forbidden();case NotFoundException() when notFound != null:
return notFound();case ServerException() when server != null:
return server(_that.message);case UnknownApiException() when unknown != null:
return unknown(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message)  network,required TResult Function()  unauthorized,required TResult Function()  forbidden,required TResult Function()  notFound,required TResult Function( String message)  server,required TResult Function( String message)  unknown,}) {final _that = this;
switch (_that) {
case NetworkException():
return network(_that.message);case UnauthorizedException():
return unauthorized();case ForbiddenException():
return forbidden();case NotFoundException():
return notFound();case ServerException():
return server(_that.message);case UnknownApiException():
return unknown(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message)?  network,TResult? Function()?  unauthorized,TResult? Function()?  forbidden,TResult? Function()?  notFound,TResult? Function( String message)?  server,TResult? Function( String message)?  unknown,}) {final _that = this;
switch (_that) {
case NetworkException() when network != null:
return network(_that.message);case UnauthorizedException() when unauthorized != null:
return unauthorized();case ForbiddenException() when forbidden != null:
return forbidden();case NotFoundException() when notFound != null:
return notFound();case ServerException() when server != null:
return server(_that.message);case UnknownApiException() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class NetworkException implements ApiException {
  const NetworkException(this.message);
  

 final  String message;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkExceptionCopyWith<NetworkException> get copyWith => _$NetworkExceptionCopyWithImpl<NetworkException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkException&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ApiException.network(message: $message)';
}


}

/// @nodoc
abstract mixin class $NetworkExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory $NetworkExceptionCopyWith(NetworkException value, $Res Function(NetworkException) _then) = _$NetworkExceptionCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NetworkExceptionCopyWithImpl<$Res>
    implements $NetworkExceptionCopyWith<$Res> {
  _$NetworkExceptionCopyWithImpl(this._self, this._then);

  final NetworkException _self;
  final $Res Function(NetworkException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NetworkException(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnauthorizedException implements ApiException {
  const UnauthorizedException();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiException.unauthorized()';
}


}




/// @nodoc


class ForbiddenException implements ApiException {
  const ForbiddenException();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForbiddenException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiException.forbidden()';
}


}




/// @nodoc


class NotFoundException implements ApiException {
  const NotFoundException();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFoundException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ApiException.notFound()';
}


}




/// @nodoc


class ServerException implements ApiException {
  const ServerException(this.message);
  

 final  String message;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerExceptionCopyWith<ServerException> get copyWith => _$ServerExceptionCopyWithImpl<ServerException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerException&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ApiException.server(message: $message)';
}


}

/// @nodoc
abstract mixin class $ServerExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory $ServerExceptionCopyWith(ServerException value, $Res Function(ServerException) _then) = _$ServerExceptionCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ServerExceptionCopyWithImpl<$Res>
    implements $ServerExceptionCopyWith<$Res> {
  _$ServerExceptionCopyWithImpl(this._self, this._then);

  final ServerException _self;
  final $Res Function(ServerException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ServerException(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnknownApiException implements ApiException {
  const UnknownApiException(this.message);
  

 final  String message;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownApiExceptionCopyWith<UnknownApiException> get copyWith => _$UnknownApiExceptionCopyWithImpl<UnknownApiException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownApiException&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ApiException.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnknownApiExceptionCopyWith<$Res> implements $ApiExceptionCopyWith<$Res> {
  factory $UnknownApiExceptionCopyWith(UnknownApiException value, $Res Function(UnknownApiException) _then) = _$UnknownApiExceptionCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UnknownApiExceptionCopyWithImpl<$Res>
    implements $UnknownApiExceptionCopyWith<$Res> {
  _$UnknownApiExceptionCopyWithImpl(this._self, this._then);

  final UnknownApiException _self;
  final $Res Function(UnknownApiException) _then;

/// Create a copy of ApiException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UnknownApiException(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
