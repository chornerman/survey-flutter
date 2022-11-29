import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.init() = _Init;

  const factory HomeState.loading() = _Loading;

  const factory HomeState.cacheLoadingSuccess() = _CacheLoadingSuccess;

  const factory HomeState.apiLoadingSuccess() = _ApiLoadingSuccess;

  const factory HomeState.error() = _Error;
}
