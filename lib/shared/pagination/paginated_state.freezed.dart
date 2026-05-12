// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaginatedState<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaginatedState<$T>()';
}


}

/// @nodoc
class $PaginatedStateCopyWith<T,$Res>  {
$PaginatedStateCopyWith(PaginatedState<T> _, $Res Function(PaginatedState<T>) __);
}


/// Adds pattern-matching-related methods to [PaginatedState].
extension PaginatedStatePatterns<T> on PaginatedState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PaginatedInitial<T> value)?  initial,TResult Function( PaginatedLoading<T> value)?  loading,TResult Function( PaginatedData<T> value)?  data,TResult Function( PaginatedError<T> value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PaginatedInitial() when initial != null:
return initial(_that);case PaginatedLoading() when loading != null:
return loading(_that);case PaginatedData() when data != null:
return data(_that);case PaginatedError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PaginatedInitial<T> value)  initial,required TResult Function( PaginatedLoading<T> value)  loading,required TResult Function( PaginatedData<T> value)  data,required TResult Function( PaginatedError<T> value)  error,}){
final _that = this;
switch (_that) {
case PaginatedInitial():
return initial(_that);case PaginatedLoading():
return loading(_that);case PaginatedData():
return data(_that);case PaginatedError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PaginatedInitial<T> value)?  initial,TResult? Function( PaginatedLoading<T> value)?  loading,TResult? Function( PaginatedData<T> value)?  data,TResult? Function( PaginatedError<T> value)?  error,}){
final _that = this;
switch (_that) {
case PaginatedInitial() when initial != null:
return initial(_that);case PaginatedLoading() when loading != null:
return loading(_that);case PaginatedData() when data != null:
return data(_that);case PaginatedError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<T> items,  int page,  bool hasMore,  bool loadingMore)?  data,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PaginatedInitial() when initial != null:
return initial();case PaginatedLoading() when loading != null:
return loading();case PaginatedData() when data != null:
return data(_that.items,_that.page,_that.hasMore,_that.loadingMore);case PaginatedError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<T> items,  int page,  bool hasMore,  bool loadingMore)  data,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case PaginatedInitial():
return initial();case PaginatedLoading():
return loading();case PaginatedData():
return data(_that.items,_that.page,_that.hasMore,_that.loadingMore);case PaginatedError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<T> items,  int page,  bool hasMore,  bool loadingMore)?  data,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case PaginatedInitial() when initial != null:
return initial();case PaginatedLoading() when loading != null:
return loading();case PaginatedData() when data != null:
return data(_that.items,_that.page,_that.hasMore,_that.loadingMore);case PaginatedError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class PaginatedInitial<T> implements PaginatedState<T> {
  const PaginatedInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedInitial<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaginatedState<$T>.initial()';
}


}




/// @nodoc


class PaginatedLoading<T> implements PaginatedState<T> {
  const PaginatedLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedLoading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PaginatedState<$T>.loading()';
}


}




/// @nodoc


class PaginatedData<T> implements PaginatedState<T> {
  const PaginatedData({required final  List<T> items, required this.page, required this.hasMore, this.loadingMore = false}): _items = items;
  

 final  List<T> _items;
 List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  int page;
 final  bool hasMore;
/// True while the next page is being fetched.
@JsonKey() final  bool loadingMore;

/// Create a copy of PaginatedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedDataCopyWith<T, PaginatedData<T>> get copyWith => _$PaginatedDataCopyWithImpl<T, PaginatedData<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedData<T>&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),page,hasMore,loadingMore);

@override
String toString() {
  return 'PaginatedState<$T>.data(items: $items, page: $page, hasMore: $hasMore, loadingMore: $loadingMore)';
}


}

/// @nodoc
abstract mixin class $PaginatedDataCopyWith<T,$Res> implements $PaginatedStateCopyWith<T, $Res> {
  factory $PaginatedDataCopyWith(PaginatedData<T> value, $Res Function(PaginatedData<T>) _then) = _$PaginatedDataCopyWithImpl;
@useResult
$Res call({
 List<T> items, int page, bool hasMore, bool loadingMore
});




}
/// @nodoc
class _$PaginatedDataCopyWithImpl<T,$Res>
    implements $PaginatedDataCopyWith<T, $Res> {
  _$PaginatedDataCopyWithImpl(this._self, this._then);

  final PaginatedData<T> _self;
  final $Res Function(PaginatedData<T>) _then;

/// Create a copy of PaginatedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? page = null,Object? hasMore = null,Object? loadingMore = null,}) {
  return _then(PaginatedData<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class PaginatedError<T> implements PaginatedState<T> {
  const PaginatedError(this.message);
  

 final  String message;

/// Create a copy of PaginatedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedErrorCopyWith<T, PaginatedError<T>> get copyWith => _$PaginatedErrorCopyWithImpl<T, PaginatedError<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedError<T>&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PaginatedState<$T>.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $PaginatedErrorCopyWith<T,$Res> implements $PaginatedStateCopyWith<T, $Res> {
  factory $PaginatedErrorCopyWith(PaginatedError<T> value, $Res Function(PaginatedError<T>) _then) = _$PaginatedErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PaginatedErrorCopyWithImpl<T,$Res>
    implements $PaginatedErrorCopyWith<T, $Res> {
  _$PaginatedErrorCopyWithImpl(this._self, this._then);

  final PaginatedError<T> _self;
  final $Res Function(PaginatedError<T>) _then;

/// Create a copy of PaginatedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PaginatedError<T>(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
