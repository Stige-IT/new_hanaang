// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'retur_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ReturStates {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int? get totalPage => throw _privateConstructorUsedError;
  List<Retur>? get data => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ReturStatesCopyWith<ReturStates> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReturStatesCopyWith<$Res> {
  factory $ReturStatesCopyWith(
          ReturStates value, $Res Function(ReturStates) then) =
      _$ReturStatesCopyWithImpl<$Res, ReturStates>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isLoadingMore,
      String? error,
      int page,
      int? totalPage,
      List<Retur>? data});
}

/// @nodoc
class _$ReturStatesCopyWithImpl<$Res, $Val extends ReturStates>
    implements $ReturStatesCopyWith<$Res> {
  _$ReturStatesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? error = freezed,
    Object? page = null,
    Object? totalPage = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      totalPage: freezed == totalPage
          ? _value.totalPage
          : totalPage // ignore: cast_nullable_to_non_nullable
              as int?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Retur>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReturStatesImplCopyWith<$Res>
    implements $ReturStatesCopyWith<$Res> {
  factory _$$ReturStatesImplCopyWith(
          _$ReturStatesImpl value, $Res Function(_$ReturStatesImpl) then) =
      __$$ReturStatesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isLoadingMore,
      String? error,
      int page,
      int? totalPage,
      List<Retur>? data});
}

/// @nodoc
class __$$ReturStatesImplCopyWithImpl<$Res>
    extends _$ReturStatesCopyWithImpl<$Res, _$ReturStatesImpl>
    implements _$$ReturStatesImplCopyWith<$Res> {
  __$$ReturStatesImplCopyWithImpl(
      _$ReturStatesImpl _value, $Res Function(_$ReturStatesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? error = freezed,
    Object? page = null,
    Object? totalPage = freezed,
    Object? data = freezed,
  }) {
    return _then(_$ReturStatesImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      totalPage: freezed == totalPage
          ? _value.totalPage
          : totalPage // ignore: cast_nullable_to_non_nullable
              as int?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Retur>?,
    ));
  }
}

/// @nodoc

class _$ReturStatesImpl implements _ReturStates {
  const _$ReturStatesImpl(
      {this.isLoading = true,
      this.isLoadingMore = false,
      this.error,
      this.page = 1,
      this.totalPage,
      final List<Retur>? data})
      : _data = data;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  final String? error;
  @override
  @JsonKey()
  final int page;
  @override
  final int? totalPage;
  final List<Retur>? _data;
  @override
  List<Retur>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ReturStates(isLoading: $isLoading, isLoadingMore: $isLoadingMore, error: $error, page: $page, totalPage: $totalPage, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReturStatesImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.totalPage, totalPage) ||
                other.totalPage == totalPage) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, isLoadingMore, error,
      page, totalPage, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReturStatesImplCopyWith<_$ReturStatesImpl> get copyWith =>
      __$$ReturStatesImplCopyWithImpl<_$ReturStatesImpl>(this, _$identity);
}

abstract class _ReturStates implements ReturStates {
  const factory _ReturStates(
      {final bool isLoading,
      final bool isLoadingMore,
      final String? error,
      final int page,
      final int? totalPage,
      final List<Retur>? data}) = _$ReturStatesImpl;

  @override
  bool get isLoading;
  @override
  bool get isLoadingMore;
  @override
  String? get error;
  @override
  int get page;
  @override
  int? get totalPage;
  @override
  List<Retur>? get data;
  @override
  @JsonKey(ignore: true)
  _$$ReturStatesImplCopyWith<_$ReturStatesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
