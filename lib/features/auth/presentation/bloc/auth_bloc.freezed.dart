// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) login,
    required TResult Function(String email, String password, String displayName)
        register,
    required TResult Function(String provider, String idToken) socialLogin,
    required TResult Function() logout,
    required TResult Function() checkStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? login,
    TResult? Function(String email, String password, String displayName)?
        register,
    TResult? Function(String provider, String idToken)? socialLogin,
    TResult? Function()? logout,
    TResult? Function()? checkStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? login,
    TResult Function(String email, String password, String displayName)?
        register,
    TResult Function(String provider, String idToken)? socialLogin,
    TResult Function()? logout,
    TResult Function()? checkStatus,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthLoginEvent value) login,
    required TResult Function(AuthRegisterEvent value) register,
    required TResult Function(AuthSocialLoginEvent value) socialLogin,
    required TResult Function(AuthLogoutEvent value) logout,
    required TResult Function(AuthCheckStatusEvent value) checkStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthLoginEvent value)? login,
    TResult? Function(AuthRegisterEvent value)? register,
    TResult? Function(AuthSocialLoginEvent value)? socialLogin,
    TResult? Function(AuthLogoutEvent value)? logout,
    TResult? Function(AuthCheckStatusEvent value)? checkStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthLoginEvent value)? login,
    TResult Function(AuthRegisterEvent value)? register,
    TResult Function(AuthSocialLoginEvent value)? socialLogin,
    TResult Function(AuthLogoutEvent value)? logout,
    TResult Function(AuthCheckStatusEvent value)? checkStatus,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthEventCopyWith<$Res> {
  factory $AuthEventCopyWith(AuthEvent value, $Res Function(AuthEvent) then) =
      _$AuthEventCopyWithImpl<$Res, AuthEvent>;
}

/// @nodoc
class _$AuthEventCopyWithImpl<$Res, $Val extends AuthEvent>
    implements $AuthEventCopyWith<$Res> {
  _$AuthEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AuthLoginEventImplCopyWith<$Res> {
  factory _$$AuthLoginEventImplCopyWith(_$AuthLoginEventImpl value,
          $Res Function(_$AuthLoginEventImpl) then) =
      __$$AuthLoginEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$AuthLoginEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthLoginEventImpl>
    implements _$$AuthLoginEventImplCopyWith<$Res> {
  __$$AuthLoginEventImplCopyWithImpl(
      _$AuthLoginEventImpl _value, $Res Function(_$AuthLoginEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_$AuthLoginEventImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthLoginEventImpl
    with DiagnosticableTreeMixin
    implements AuthLoginEvent {
  const _$AuthLoginEventImpl({required this.email, required this.password});

  @override
  final String email;
  @override
  final String password;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthEvent.login(email: $email, password: $password)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthEvent.login'))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('password', password));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthLoginEventImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthLoginEventImplCopyWith<_$AuthLoginEventImpl> get copyWith =>
      __$$AuthLoginEventImplCopyWithImpl<_$AuthLoginEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) login,
    required TResult Function(String email, String password, String displayName)
        register,
    required TResult Function(String provider, String idToken) socialLogin,
    required TResult Function() logout,
    required TResult Function() checkStatus,
  }) {
    return login(email, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? login,
    TResult? Function(String email, String password, String displayName)?
        register,
    TResult? Function(String provider, String idToken)? socialLogin,
    TResult? Function()? logout,
    TResult? Function()? checkStatus,
  }) {
    return login?.call(email, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? login,
    TResult Function(String email, String password, String displayName)?
        register,
    TResult Function(String provider, String idToken)? socialLogin,
    TResult Function()? logout,
    TResult Function()? checkStatus,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(email, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthLoginEvent value) login,
    required TResult Function(AuthRegisterEvent value) register,
    required TResult Function(AuthSocialLoginEvent value) socialLogin,
    required TResult Function(AuthLogoutEvent value) logout,
    required TResult Function(AuthCheckStatusEvent value) checkStatus,
  }) {
    return login(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthLoginEvent value)? login,
    TResult? Function(AuthRegisterEvent value)? register,
    TResult? Function(AuthSocialLoginEvent value)? socialLogin,
    TResult? Function(AuthLogoutEvent value)? logout,
    TResult? Function(AuthCheckStatusEvent value)? checkStatus,
  }) {
    return login?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthLoginEvent value)? login,
    TResult Function(AuthRegisterEvent value)? register,
    TResult Function(AuthSocialLoginEvent value)? socialLogin,
    TResult Function(AuthLogoutEvent value)? logout,
    TResult Function(AuthCheckStatusEvent value)? checkStatus,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(this);
    }
    return orElse();
  }
}

abstract class AuthLoginEvent implements AuthEvent {
  const factory AuthLoginEvent(
      {required final String email,
      required final String password}) = _$AuthLoginEventImpl;

  String get email;
  String get password;
  @JsonKey(ignore: true)
  _$$AuthLoginEventImplCopyWith<_$AuthLoginEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthRegisterEventImplCopyWith<$Res> {
  factory _$$AuthRegisterEventImplCopyWith(_$AuthRegisterEventImpl value,
          $Res Function(_$AuthRegisterEventImpl) then) =
      __$$AuthRegisterEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String password, String displayName});
}

/// @nodoc
class __$$AuthRegisterEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthRegisterEventImpl>
    implements _$$AuthRegisterEventImplCopyWith<$Res> {
  __$$AuthRegisterEventImplCopyWithImpl(_$AuthRegisterEventImpl _value,
      $Res Function(_$AuthRegisterEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? displayName = null,
  }) {
    return _then(_$AuthRegisterEventImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthRegisterEventImpl
    with DiagnosticableTreeMixin
    implements AuthRegisterEvent {
  const _$AuthRegisterEventImpl(
      {required this.email, required this.password, required this.displayName});

  @override
  final String email;
  @override
  final String password;
  @override
  final String displayName;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthEvent.register(email: $email, password: $password, displayName: $displayName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthEvent.register'))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('password', password))
      ..add(DiagnosticsProperty('displayName', displayName));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthRegisterEventImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password, displayName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthRegisterEventImplCopyWith<_$AuthRegisterEventImpl> get copyWith =>
      __$$AuthRegisterEventImplCopyWithImpl<_$AuthRegisterEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) login,
    required TResult Function(String email, String password, String displayName)
        register,
    required TResult Function(String provider, String idToken) socialLogin,
    required TResult Function() logout,
    required TResult Function() checkStatus,
  }) {
    return register(email, password, displayName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? login,
    TResult? Function(String email, String password, String displayName)?
        register,
    TResult? Function(String provider, String idToken)? socialLogin,
    TResult? Function()? logout,
    TResult? Function()? checkStatus,
  }) {
    return register?.call(email, password, displayName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? login,
    TResult Function(String email, String password, String displayName)?
        register,
    TResult Function(String provider, String idToken)? socialLogin,
    TResult Function()? logout,
    TResult Function()? checkStatus,
    required TResult orElse(),
  }) {
    if (register != null) {
      return register(email, password, displayName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthLoginEvent value) login,
    required TResult Function(AuthRegisterEvent value) register,
    required TResult Function(AuthSocialLoginEvent value) socialLogin,
    required TResult Function(AuthLogoutEvent value) logout,
    required TResult Function(AuthCheckStatusEvent value) checkStatus,
  }) {
    return register(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthLoginEvent value)? login,
    TResult? Function(AuthRegisterEvent value)? register,
    TResult? Function(AuthSocialLoginEvent value)? socialLogin,
    TResult? Function(AuthLogoutEvent value)? logout,
    TResult? Function(AuthCheckStatusEvent value)? checkStatus,
  }) {
    return register?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthLoginEvent value)? login,
    TResult Function(AuthRegisterEvent value)? register,
    TResult Function(AuthSocialLoginEvent value)? socialLogin,
    TResult Function(AuthLogoutEvent value)? logout,
    TResult Function(AuthCheckStatusEvent value)? checkStatus,
    required TResult orElse(),
  }) {
    if (register != null) {
      return register(this);
    }
    return orElse();
  }
}

abstract class AuthRegisterEvent implements AuthEvent {
  const factory AuthRegisterEvent(
      {required final String email,
      required final String password,
      required final String displayName}) = _$AuthRegisterEventImpl;

  String get email;
  String get password;
  String get displayName;
  @JsonKey(ignore: true)
  _$$AuthRegisterEventImplCopyWith<_$AuthRegisterEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthSocialLoginEventImplCopyWith<$Res> {
  factory _$$AuthSocialLoginEventImplCopyWith(_$AuthSocialLoginEventImpl value,
          $Res Function(_$AuthSocialLoginEventImpl) then) =
      __$$AuthSocialLoginEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String provider, String idToken});
}

/// @nodoc
class __$$AuthSocialLoginEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthSocialLoginEventImpl>
    implements _$$AuthSocialLoginEventImplCopyWith<$Res> {
  __$$AuthSocialLoginEventImplCopyWithImpl(_$AuthSocialLoginEventImpl _value,
      $Res Function(_$AuthSocialLoginEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? idToken = null,
  }) {
    return _then(_$AuthSocialLoginEventImpl(
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      idToken: null == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthSocialLoginEventImpl
    with DiagnosticableTreeMixin
    implements AuthSocialLoginEvent {
  const _$AuthSocialLoginEventImpl(
      {required this.provider, required this.idToken});

  @override
  final String provider;
  @override
  final String idToken;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthEvent.socialLogin(provider: $provider, idToken: $idToken)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthEvent.socialLogin'))
      ..add(DiagnosticsProperty('provider', provider))
      ..add(DiagnosticsProperty('idToken', idToken));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSocialLoginEventImpl &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.idToken, idToken) || other.idToken == idToken));
  }

  @override
  int get hashCode => Object.hash(runtimeType, provider, idToken);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthSocialLoginEventImplCopyWith<_$AuthSocialLoginEventImpl>
      get copyWith =>
          __$$AuthSocialLoginEventImplCopyWithImpl<_$AuthSocialLoginEventImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) login,
    required TResult Function(String email, String password, String displayName)
        register,
    required TResult Function(String provider, String idToken) socialLogin,
    required TResult Function() logout,
    required TResult Function() checkStatus,
  }) {
    return socialLogin(provider, idToken);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? login,
    TResult? Function(String email, String password, String displayName)?
        register,
    TResult? Function(String provider, String idToken)? socialLogin,
    TResult? Function()? logout,
    TResult? Function()? checkStatus,
  }) {
    return socialLogin?.call(provider, idToken);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? login,
    TResult Function(String email, String password, String displayName)?
        register,
    TResult Function(String provider, String idToken)? socialLogin,
    TResult Function()? logout,
    TResult Function()? checkStatus,
    required TResult orElse(),
  }) {
    if (socialLogin != null) {
      return socialLogin(provider, idToken);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthLoginEvent value) login,
    required TResult Function(AuthRegisterEvent value) register,
    required TResult Function(AuthSocialLoginEvent value) socialLogin,
    required TResult Function(AuthLogoutEvent value) logout,
    required TResult Function(AuthCheckStatusEvent value) checkStatus,
  }) {
    return socialLogin(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthLoginEvent value)? login,
    TResult? Function(AuthRegisterEvent value)? register,
    TResult? Function(AuthSocialLoginEvent value)? socialLogin,
    TResult? Function(AuthLogoutEvent value)? logout,
    TResult? Function(AuthCheckStatusEvent value)? checkStatus,
  }) {
    return socialLogin?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthLoginEvent value)? login,
    TResult Function(AuthRegisterEvent value)? register,
    TResult Function(AuthSocialLoginEvent value)? socialLogin,
    TResult Function(AuthLogoutEvent value)? logout,
    TResult Function(AuthCheckStatusEvent value)? checkStatus,
    required TResult orElse(),
  }) {
    if (socialLogin != null) {
      return socialLogin(this);
    }
    return orElse();
  }
}

abstract class AuthSocialLoginEvent implements AuthEvent {
  const factory AuthSocialLoginEvent(
      {required final String provider,
      required final String idToken}) = _$AuthSocialLoginEventImpl;

  String get provider;
  String get idToken;
  @JsonKey(ignore: true)
  _$$AuthSocialLoginEventImplCopyWith<_$AuthSocialLoginEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthLogoutEventImplCopyWith<$Res> {
  factory _$$AuthLogoutEventImplCopyWith(_$AuthLogoutEventImpl value,
          $Res Function(_$AuthLogoutEventImpl) then) =
      __$$AuthLogoutEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthLogoutEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthLogoutEventImpl>
    implements _$$AuthLogoutEventImplCopyWith<$Res> {
  __$$AuthLogoutEventImplCopyWithImpl(
      _$AuthLogoutEventImpl _value, $Res Function(_$AuthLogoutEventImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AuthLogoutEventImpl
    with DiagnosticableTreeMixin
    implements AuthLogoutEvent {
  const _$AuthLogoutEventImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthEvent.logout()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'AuthEvent.logout'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthLogoutEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) login,
    required TResult Function(String email, String password, String displayName)
        register,
    required TResult Function(String provider, String idToken) socialLogin,
    required TResult Function() logout,
    required TResult Function() checkStatus,
  }) {
    return logout();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? login,
    TResult? Function(String email, String password, String displayName)?
        register,
    TResult? Function(String provider, String idToken)? socialLogin,
    TResult? Function()? logout,
    TResult? Function()? checkStatus,
  }) {
    return logout?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? login,
    TResult Function(String email, String password, String displayName)?
        register,
    TResult Function(String provider, String idToken)? socialLogin,
    TResult Function()? logout,
    TResult Function()? checkStatus,
    required TResult orElse(),
  }) {
    if (logout != null) {
      return logout();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthLoginEvent value) login,
    required TResult Function(AuthRegisterEvent value) register,
    required TResult Function(AuthSocialLoginEvent value) socialLogin,
    required TResult Function(AuthLogoutEvent value) logout,
    required TResult Function(AuthCheckStatusEvent value) checkStatus,
  }) {
    return logout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthLoginEvent value)? login,
    TResult? Function(AuthRegisterEvent value)? register,
    TResult? Function(AuthSocialLoginEvent value)? socialLogin,
    TResult? Function(AuthLogoutEvent value)? logout,
    TResult? Function(AuthCheckStatusEvent value)? checkStatus,
  }) {
    return logout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthLoginEvent value)? login,
    TResult Function(AuthRegisterEvent value)? register,
    TResult Function(AuthSocialLoginEvent value)? socialLogin,
    TResult Function(AuthLogoutEvent value)? logout,
    TResult Function(AuthCheckStatusEvent value)? checkStatus,
    required TResult orElse(),
  }) {
    if (logout != null) {
      return logout(this);
    }
    return orElse();
  }
}

abstract class AuthLogoutEvent implements AuthEvent {
  const factory AuthLogoutEvent() = _$AuthLogoutEventImpl;
}

/// @nodoc
abstract class _$$AuthCheckStatusEventImplCopyWith<$Res> {
  factory _$$AuthCheckStatusEventImplCopyWith(_$AuthCheckStatusEventImpl value,
          $Res Function(_$AuthCheckStatusEventImpl) then) =
      __$$AuthCheckStatusEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthCheckStatusEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthCheckStatusEventImpl>
    implements _$$AuthCheckStatusEventImplCopyWith<$Res> {
  __$$AuthCheckStatusEventImplCopyWithImpl(_$AuthCheckStatusEventImpl _value,
      $Res Function(_$AuthCheckStatusEventImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AuthCheckStatusEventImpl
    with DiagnosticableTreeMixin
    implements AuthCheckStatusEvent {
  const _$AuthCheckStatusEventImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthEvent.checkStatus()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'AuthEvent.checkStatus'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthCheckStatusEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) login,
    required TResult Function(String email, String password, String displayName)
        register,
    required TResult Function(String provider, String idToken) socialLogin,
    required TResult Function() logout,
    required TResult Function() checkStatus,
  }) {
    return checkStatus();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? login,
    TResult? Function(String email, String password, String displayName)?
        register,
    TResult? Function(String provider, String idToken)? socialLogin,
    TResult? Function()? logout,
    TResult? Function()? checkStatus,
  }) {
    return checkStatus?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? login,
    TResult Function(String email, String password, String displayName)?
        register,
    TResult Function(String provider, String idToken)? socialLogin,
    TResult Function()? logout,
    TResult Function()? checkStatus,
    required TResult orElse(),
  }) {
    if (checkStatus != null) {
      return checkStatus();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthLoginEvent value) login,
    required TResult Function(AuthRegisterEvent value) register,
    required TResult Function(AuthSocialLoginEvent value) socialLogin,
    required TResult Function(AuthLogoutEvent value) logout,
    required TResult Function(AuthCheckStatusEvent value) checkStatus,
  }) {
    return checkStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthLoginEvent value)? login,
    TResult? Function(AuthRegisterEvent value)? register,
    TResult? Function(AuthSocialLoginEvent value)? socialLogin,
    TResult? Function(AuthLogoutEvent value)? logout,
    TResult? Function(AuthCheckStatusEvent value)? checkStatus,
  }) {
    return checkStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthLoginEvent value)? login,
    TResult Function(AuthRegisterEvent value)? register,
    TResult Function(AuthSocialLoginEvent value)? socialLogin,
    TResult Function(AuthLogoutEvent value)? logout,
    TResult Function(AuthCheckStatusEvent value)? checkStatus,
    required TResult orElse(),
  }) {
    if (checkStatus != null) {
      return checkStatus(this);
    }
    return orElse();
  }
}

abstract class AuthCheckStatusEvent implements AuthEvent {
  const factory AuthCheckStatusEvent() = _$AuthCheckStatusEventImpl;
}

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            String userId, String email, String token, String displayName)
        authenticated,
    required TResult Function(String email, String message)
        emailConfirmationRequired,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            String userId, String email, String token, String displayName)?
        authenticated,
    TResult? Function(String email, String message)? emailConfirmationRequired,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            String userId, String email, String token, String displayName)?
        authenticated,
    TResult Function(String email, String message)? emailConfirmationRequired,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AuthInitial value) initial,
    required TResult Function(_AuthLoading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_EmailConfirmationRequired value)
        emailConfirmationRequired,
    required TResult Function(_AuthError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AuthInitial value)? initial,
    TResult? Function(_AuthLoading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_EmailConfirmationRequired value)?
        emailConfirmationRequired,
    TResult? Function(_AuthError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AuthInitial value)? initial,
    TResult Function(_AuthLoading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_EmailConfirmationRequired value)?
        emailConfirmationRequired,
    TResult Function(_AuthError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AuthInitialImplCopyWith<$Res> {
  factory _$$AuthInitialImplCopyWith(
          _$AuthInitialImpl value, $Res Function(_$AuthInitialImpl) then) =
      __$$AuthInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthInitialImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthInitialImpl>
    implements _$$AuthInitialImplCopyWith<$Res> {
  __$$AuthInitialImplCopyWithImpl(
      _$AuthInitialImpl _value, $Res Function(_$AuthInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AuthInitialImpl with DiagnosticableTreeMixin implements _AuthInitial {
  const _$AuthInitialImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthState.initial()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'AuthState.initial'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            String userId, String email, String token, String displayName)
        authenticated,
    required TResult Function(String email, String message)
        emailConfirmationRequired,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            String userId, String email, String token, String displayName)?
        authenticated,
    TResult? Function(String email, String message)? emailConfirmationRequired,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            String userId, String email, String token, String displayName)?
        authenticated,
    TResult Function(String email, String message)? emailConfirmationRequired,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AuthInitial value) initial,
    required TResult Function(_AuthLoading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_EmailConfirmationRequired value)
        emailConfirmationRequired,
    required TResult Function(_AuthError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AuthInitial value)? initial,
    TResult? Function(_AuthLoading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_EmailConfirmationRequired value)?
        emailConfirmationRequired,
    TResult? Function(_AuthError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AuthInitial value)? initial,
    TResult Function(_AuthLoading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_EmailConfirmationRequired value)?
        emailConfirmationRequired,
    TResult Function(_AuthError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _AuthInitial implements AuthState {
  const factory _AuthInitial() = _$AuthInitialImpl;
}

/// @nodoc
abstract class _$$AuthLoadingImplCopyWith<$Res> {
  factory _$$AuthLoadingImplCopyWith(
          _$AuthLoadingImpl value, $Res Function(_$AuthLoadingImpl) then) =
      __$$AuthLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthLoadingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthLoadingImpl>
    implements _$$AuthLoadingImplCopyWith<$Res> {
  __$$AuthLoadingImplCopyWithImpl(
      _$AuthLoadingImpl _value, $Res Function(_$AuthLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AuthLoadingImpl with DiagnosticableTreeMixin implements _AuthLoading {
  const _$AuthLoadingImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthState.loading()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'AuthState.loading'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            String userId, String email, String token, String displayName)
        authenticated,
    required TResult Function(String email, String message)
        emailConfirmationRequired,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            String userId, String email, String token, String displayName)?
        authenticated,
    TResult? Function(String email, String message)? emailConfirmationRequired,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            String userId, String email, String token, String displayName)?
        authenticated,
    TResult Function(String email, String message)? emailConfirmationRequired,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AuthInitial value) initial,
    required TResult Function(_AuthLoading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_EmailConfirmationRequired value)
        emailConfirmationRequired,
    required TResult Function(_AuthError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AuthInitial value)? initial,
    TResult? Function(_AuthLoading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_EmailConfirmationRequired value)?
        emailConfirmationRequired,
    TResult? Function(_AuthError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AuthInitial value)? initial,
    TResult Function(_AuthLoading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_EmailConfirmationRequired value)?
        emailConfirmationRequired,
    TResult Function(_AuthError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _AuthLoading implements AuthState {
  const factory _AuthLoading() = _$AuthLoadingImpl;
}

/// @nodoc
abstract class _$$AuthenticatedImplCopyWith<$Res> {
  factory _$$AuthenticatedImplCopyWith(
          _$AuthenticatedImpl value, $Res Function(_$AuthenticatedImpl) then) =
      __$$AuthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId, String email, String token, String displayName});
}

/// @nodoc
class __$$AuthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthenticatedImpl>
    implements _$$AuthenticatedImplCopyWith<$Res> {
  __$$AuthenticatedImplCopyWithImpl(
      _$AuthenticatedImpl _value, $Res Function(_$AuthenticatedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? token = null,
    Object? displayName = null,
  }) {
    return _then(_$AuthenticatedImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthenticatedImpl
    with DiagnosticableTreeMixin
    implements _Authenticated {
  const _$AuthenticatedImpl(
      {required this.userId,
      required this.email,
      required this.token,
      required this.displayName});

  @override
  final String userId;
  @override
  final String email;
  @override
  final String token;
  @override
  final String displayName;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthState.authenticated(userId: $userId, email: $email, token: $token, displayName: $displayName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthState.authenticated'))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('token', token))
      ..add(DiagnosticsProperty('displayName', displayName));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticatedImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, email, token, displayName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticatedImplCopyWith<_$AuthenticatedImpl> get copyWith =>
      __$$AuthenticatedImplCopyWithImpl<_$AuthenticatedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            String userId, String email, String token, String displayName)
        authenticated,
    required TResult Function(String email, String message)
        emailConfirmationRequired,
    required TResult Function(String message) error,
  }) {
    return authenticated(userId, email, token, displayName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            String userId, String email, String token, String displayName)?
        authenticated,
    TResult? Function(String email, String message)? emailConfirmationRequired,
    TResult? Function(String message)? error,
  }) {
    return authenticated?.call(userId, email, token, displayName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            String userId, String email, String token, String displayName)?
        authenticated,
    TResult Function(String email, String message)? emailConfirmationRequired,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(userId, email, token, displayName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AuthInitial value) initial,
    required TResult Function(_AuthLoading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_EmailConfirmationRequired value)
        emailConfirmationRequired,
    required TResult Function(_AuthError value) error,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AuthInitial value)? initial,
    TResult? Function(_AuthLoading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_EmailConfirmationRequired value)?
        emailConfirmationRequired,
    TResult? Function(_AuthError value)? error,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AuthInitial value)? initial,
    TResult Function(_AuthLoading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_EmailConfirmationRequired value)?
        emailConfirmationRequired,
    TResult Function(_AuthError value)? error,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class _Authenticated implements AuthState {
  const factory _Authenticated(
      {required final String userId,
      required final String email,
      required final String token,
      required final String displayName}) = _$AuthenticatedImpl;

  String get userId;
  String get email;
  String get token;
  String get displayName;
  @JsonKey(ignore: true)
  _$$AuthenticatedImplCopyWith<_$AuthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EmailConfirmationRequiredImplCopyWith<$Res> {
  factory _$$EmailConfirmationRequiredImplCopyWith(
          _$EmailConfirmationRequiredImpl value,
          $Res Function(_$EmailConfirmationRequiredImpl) then) =
      __$$EmailConfirmationRequiredImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String message});
}

/// @nodoc
class __$$EmailConfirmationRequiredImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$EmailConfirmationRequiredImpl>
    implements _$$EmailConfirmationRequiredImplCopyWith<$Res> {
  __$$EmailConfirmationRequiredImplCopyWithImpl(
      _$EmailConfirmationRequiredImpl _value,
      $Res Function(_$EmailConfirmationRequiredImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? message = null,
  }) {
    return _then(_$EmailConfirmationRequiredImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$EmailConfirmationRequiredImpl
    with DiagnosticableTreeMixin
    implements _EmailConfirmationRequired {
  const _$EmailConfirmationRequiredImpl(
      {required this.email, required this.message});

  @override
  final String email;
  @override
  final String message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthState.emailConfirmationRequired(email: $email, message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthState.emailConfirmationRequired'))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailConfirmationRequiredImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailConfirmationRequiredImplCopyWith<_$EmailConfirmationRequiredImpl>
      get copyWith => __$$EmailConfirmationRequiredImplCopyWithImpl<
          _$EmailConfirmationRequiredImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            String userId, String email, String token, String displayName)
        authenticated,
    required TResult Function(String email, String message)
        emailConfirmationRequired,
    required TResult Function(String message) error,
  }) {
    return emailConfirmationRequired(email, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            String userId, String email, String token, String displayName)?
        authenticated,
    TResult? Function(String email, String message)? emailConfirmationRequired,
    TResult? Function(String message)? error,
  }) {
    return emailConfirmationRequired?.call(email, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            String userId, String email, String token, String displayName)?
        authenticated,
    TResult Function(String email, String message)? emailConfirmationRequired,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (emailConfirmationRequired != null) {
      return emailConfirmationRequired(email, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AuthInitial value) initial,
    required TResult Function(_AuthLoading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_EmailConfirmationRequired value)
        emailConfirmationRequired,
    required TResult Function(_AuthError value) error,
  }) {
    return emailConfirmationRequired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AuthInitial value)? initial,
    TResult? Function(_AuthLoading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_EmailConfirmationRequired value)?
        emailConfirmationRequired,
    TResult? Function(_AuthError value)? error,
  }) {
    return emailConfirmationRequired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AuthInitial value)? initial,
    TResult Function(_AuthLoading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_EmailConfirmationRequired value)?
        emailConfirmationRequired,
    TResult Function(_AuthError value)? error,
    required TResult orElse(),
  }) {
    if (emailConfirmationRequired != null) {
      return emailConfirmationRequired(this);
    }
    return orElse();
  }
}

abstract class _EmailConfirmationRequired implements AuthState {
  const factory _EmailConfirmationRequired(
      {required final String email,
      required final String message}) = _$EmailConfirmationRequiredImpl;

  String get email;
  String get message;
  @JsonKey(ignore: true)
  _$$EmailConfirmationRequiredImplCopyWith<_$EmailConfirmationRequiredImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthErrorImplCopyWith<$Res> {
  factory _$$AuthErrorImplCopyWith(
          _$AuthErrorImpl value, $Res Function(_$AuthErrorImpl) then) =
      __$$AuthErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AuthErrorImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthErrorImpl>
    implements _$$AuthErrorImplCopyWith<$Res> {
  __$$AuthErrorImplCopyWithImpl(
      _$AuthErrorImpl _value, $Res Function(_$AuthErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$AuthErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthErrorImpl with DiagnosticableTreeMixin implements _AuthError {
  const _$AuthErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthState.error(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthState.error'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      __$$AuthErrorImplCopyWithImpl<_$AuthErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            String userId, String email, String token, String displayName)
        authenticated,
    required TResult Function(String email, String message)
        emailConfirmationRequired,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            String userId, String email, String token, String displayName)?
        authenticated,
    TResult? Function(String email, String message)? emailConfirmationRequired,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            String userId, String email, String token, String displayName)?
        authenticated,
    TResult Function(String email, String message)? emailConfirmationRequired,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AuthInitial value) initial,
    required TResult Function(_AuthLoading value) loading,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_EmailConfirmationRequired value)
        emailConfirmationRequired,
    required TResult Function(_AuthError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AuthInitial value)? initial,
    TResult? Function(_AuthLoading value)? loading,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_EmailConfirmationRequired value)?
        emailConfirmationRequired,
    TResult? Function(_AuthError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AuthInitial value)? initial,
    TResult Function(_AuthLoading value)? loading,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_EmailConfirmationRequired value)?
        emailConfirmationRequired,
    TResult Function(_AuthError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _AuthError implements AuthState {
  const factory _AuthError(final String message) = _$AuthErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
