import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/page/surveydetail/survey_detail_page.dart';
import 'package:survey/page/surveydetail/survey_detail_state.dart';
import 'package:survey/page/surveydetail/survey_detail_view_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';

import '../../mock/mock_dependencies.mocks.dart';

void main() {
  group('SurveyDetailViewModelTest', () {
    late MockGetSurveyDetailUseCase mockGetSurveyDetailUseCase;
    late ProviderContainer providerContainer;
    late SurveyDetailViewModel surveyDetailViewModel;

    final survey = MockSurveyModel();

    setUp(() {
      mockGetSurveyDetailUseCase = MockGetSurveyDetailUseCase();

      providerContainer = ProviderContainer(
        overrides: [
          surveyDetailViewModelProvider.overrideWithValue(
              SurveyDetailViewModel(mockGetSurveyDetailUseCase)),
        ],
      );
      addTearDown(providerContainer.dispose);
      surveyDetailViewModel =
          providerContainer.read(surveyDetailViewModelProvider.notifier);
    });

    test('When initializing, it initializes with Init state', () {
      expect(
        providerContainer.read(surveyDetailViewModelProvider),
        const SurveyDetailState.init(),
      );
    });

    test(
        'When calling get survey detail with Success result and isRetry is false, it emits SurveyModel, SurveyDetailModel and returns Success state',
        () {
      final surveyDetail = MockSurveyDetailModel();
      when(mockGetSurveyDetailUseCase.call(any))
          .thenAnswer((_) async => Success(surveyDetail));
      final stateStream = surveyDetailViewModel.stream;
      final surveyStream = surveyDetailViewModel.survey;
      final surveyDetailStream = surveyDetailViewModel.surveyDetail;

      expect(
          stateStream,
          emitsInOrder([
            const SurveyDetailState.loading(),
            const SurveyDetailState.success(),
          ]));
      expect(surveyStream, emitsInOrder([survey]));
      expect(surveyDetailStream, emitsInOrder([surveyDetail]));

      surveyDetailViewModel.getSurveyDetail(survey);
    });

    test(
        'When calling get survey detail with Success result and isRetry is true, it emits SurveyDetailModel and returns RetrySuccess state',
        () {
      final surveyDetail = MockSurveyDetailModel();
      when(mockGetSurveyDetailUseCase.call(any))
          .thenAnswer((_) async => Success(surveyDetail));
      final stateStream = surveyDetailViewModel.stream;
      final surveyDetailStream = surveyDetailViewModel.surveyDetail;

      expect(
          stateStream,
          emitsInOrder([
            const SurveyDetailState.loading(),
            const SurveyDetailState.retrySuccess(),
          ]));
      expect(surveyDetailStream, emitsInOrder([surveyDetail]));

      surveyDetailViewModel.getSurveyDetail(survey, isRetry: true);
    });

    test(
        'When calling get survey detail with Failed result, it returns Error state with corresponding errorMessage',
        () {
      final mockException = MockUseCaseException();
      when(mockException.actualException)
          .thenReturn(NetworkExceptions.badRequest());
      when(mockGetSurveyDetailUseCase.call(any))
          .thenAnswer((_) async => Failed(mockException));
      final stateStream = surveyDetailViewModel.stream;

      expect(
          stateStream,
          emitsInOrder([
            const SurveyDetailState.loading(),
            SurveyDetailState.error(
              NetworkExceptions.getErrorMessage(NetworkExceptions.badRequest()),
            ),
          ]));

      surveyDetailViewModel.getSurveyDetail(survey);
    });
  });
}
