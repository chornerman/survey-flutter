import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.init() = _Init;

  const factory LoginState.loading() = _Loading;

  const factory LoginState.success() = _Success;

  const factory LoginState.apiError(String errorMessage) = _ApiError;

  const factory LoginState.invalidInputsError() = _InvalidInputsError;
}
