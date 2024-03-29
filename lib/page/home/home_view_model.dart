import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/subjects.dart';
import 'package:survey/constants.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/model/user_model.dart';
import 'package:survey/page/home/home_state.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/get_cached_surveys_use_case.dart';
import 'package:survey/usecase/get_surveys_use_case.dart';
import 'package:survey/usecase/get_user_use_case.dart';
import 'package:survey/usecase/logout_use_case.dart';

const homeCurrentDatePattern = 'EEEE, MMMM dd';
const _surveysPageSize = 5;

class HomeViewModel extends StateNotifier<HomeState> {
  final GetUserUseCase _getUserUseCase;
  final GetSurveysUseCase _getSurveysUseCase;
  final GetCachedSurveysUseCase _getCachedSurveysUseCase;
  final LogoutUseCase _logoutUseCase;

  HomeViewModel(
    this._getUserUseCase,
    this._getSurveysUseCase,
    this._getCachedSurveysUseCase,
    this._logoutUseCase,
  ) : super(const HomeState.init());

  int _surveysPageNumber = 1;

  final BehaviorSubject<UserModel> _user = BehaviorSubject();

  Stream<UserModel> get user => _user.stream;

  final BehaviorSubject<List<SurveyModel>> _surveys = BehaviorSubject();

  Stream<List<SurveyModel>> get surveys => _surveys.stream;

  final PublishSubject<void> _jumpToFirstSurveysPage = PublishSubject();

  Stream<void> get jumpToFirstSurveysPage => _jumpToFirstSurveysPage.stream;

  final PublishSubject<String?> _error = PublishSubject();

  Stream<String?> get error => _error.stream;

  Stream<String> get appVersion => _getFormattedAppVersion().asStream();

  void getUser() async {
    final result = await _getUserUseCase.call();
    if (result is Success<UserModel>) {
      _user.add(result.value);
    } else {
      _error.add((result as Failed).getErrorMessage());
    }
  }

  void loadSurveysFromCache() async {
    final surveys = _getCachedSurveysUseCase.call();
    if (surveys.isNotEmpty && state != HomeState.apiLoadingSuccess()) {
      _surveys.add(surveys);
      state = const HomeState.cacheLoadingSuccess();
    }
  }

  void loadSurveysFromApi() async {
    if (_surveysPageNumber > 1) state = const HomeState.loading();

    final result = await _getSurveysUseCase.call(GetSurveysInput(
      pageNumber: _surveysPageNumber,
      pageSize: _surveysPageSize,
    ));
    if (result is Success<List<SurveyModel>>) {
      final newSurveys = result.value;
      if (_surveysPageNumber == 1) {
        _surveys.add(newSurveys);
      } else {
        final currentSurveys = _surveys.value;
        currentSurveys.addAll(newSurveys);
        _surveys.add(currentSurveys);
      }
      state = const HomeState.apiLoadingSuccess();
      _surveysPageNumber++;
    } else {
      _handleLoadSurveysError((result as Failed).getErrorMessage());
    }
  }

  Future<void> refreshSurveys() async {
    if (_surveys.hasValue) _jumpToFirstSurveysPage.add(Object);

    final result = await _getSurveysUseCase.call(GetSurveysInput(
      pageNumber: Constants.firstSurveysPageNumber,
      pageSize: _surveys.hasValue ? _surveys.value.length : _surveysPageSize,
    ));
    if (result is Success<List<SurveyModel>>) {
      final surveys = result.value;
      _surveys.add(surveys);
      state = const HomeState.apiLoadingSuccess();
    } else {
      _handleLoadSurveysError((result as Failed).getErrorMessage());
    }
  }

  void logout() async {
    state = const HomeState.loading();

    final result = await _logoutUseCase.call();
    if (result is Success<void>) {
      state = const HomeState.logoutSuccess();
    } else {
      _error.add((result as Failed).getErrorMessage());
    }
  }

  String getCurrentDate() =>
      DateFormat(homeCurrentDatePattern).format(clock.now()).toUpperCase();

  void clearError() {
    _error.add(null);
  }

  Future<String> _getFormattedAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return "v${packageInfo.version} (${packageInfo.buildNumber})";
    } catch (exception) {
      return '';
    }
  }

  void _handleLoadSurveysError(String errorMessage) {
    _error.add(errorMessage);
    state = HomeState.loadSurveysError();
  }

  @override
  void dispose() async {
    await _user.close();
    await _surveys.close();
    await _jumpToFirstSurveysPage.close();
    await _error.close();
    super.dispose();
  }
}
