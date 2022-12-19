import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_state.freezed.dart';

@freezed
class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState.init() = _Init;

  const factory ResetPasswordState.loading() = _Loading;

  const factory ResetPasswordState.success() = _Success;

  const factory ResetPasswordState.apiError(String errorMessage) = _ApiError;

  const factory ResetPasswordState.invalidInputError() = _InvalidInputError;
}
