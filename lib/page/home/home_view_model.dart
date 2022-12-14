import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/page/home/home_state.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/get_cached_surveys_use_case.dart';
import 'package:survey/usecase/get_surveys_use_case.dart';

const _homeCurrentDatePattern = 'EEEE, MMMM dd';
const _surveysPageSize = 5;

class HomeViewModel extends StateNotifier<HomeState> {
  final GetSurveysUseCase _getSurveysUseCase;
  final GetCachedSurveysUseCase _getCachedSurveysUseCase;

  HomeViewModel(
    this._getSurveysUseCase,
    this._getCachedSurveysUseCase,
  ) : super(const HomeState.init());

  int _surveysPageNumber = 1;

  final BehaviorSubject<List<SurveyModel>> _surveys = BehaviorSubject();

  Stream<List<SurveyModel>> get surveys => _surveys.stream;

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
      state = HomeState.error((result as Failed).exception);
    }
  }

  String getCurrentDate() =>
      DateFormat(_homeCurrentDatePattern).format(clock.now()).toUpperCase();

  @override
  void dispose() async {
    await _surveys.close();
    super.dispose();
  }
}
