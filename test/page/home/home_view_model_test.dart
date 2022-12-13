import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/page/home/home_page.dart';
import 'package:survey/page/home/home_state.dart';
import 'package:survey/page/home/home_view_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';

import '../../mock/mock_dependencies.mocks.dart';

void main() {
  group('HomeViewModelTest', () {
    late MockGetSurveysUseCase mockGetSurveysUseCase;
    late MockGetCachedSurveysUseCase mockGetCachedSurveysUseCase;
    late ProviderContainer providerContainer;
    late HomeViewModel homeViewModel;

    final List<SurveyModel> cachedSurveys = <SurveyModel>[
      SurveyModel(
        id: '1',
        title: 'Title1',
        description: 'Description1',
        coverImageUrl: 'CoverImageUrl1',
      )
    ];
    final List<SurveyModel> surveys = <SurveyModel>[
      SurveyModel(
        id: '2',
        title: 'Title2',
        description: 'Description2',
        coverImageUrl: 'CoverImageUrl2',
      ),
    ];

    setUp(() {
      mockGetSurveysUseCase = MockGetSurveysUseCase();
      mockGetCachedSurveysUseCase = MockGetCachedSurveysUseCase();

      when(mockGetCachedSurveysUseCase.call()).thenAnswer((_) => cachedSurveys);

      providerContainer = ProviderContainer(
        overrides: [
          homeViewModelProvider.overrideWithValue(HomeViewModel(
            mockGetSurveysUseCase,
            mockGetCachedSurveysUseCase,
          )),
        ],
      );
      addTearDown(providerContainer.dispose);
      homeViewModel = providerContainer.read(homeViewModelProvider.notifier);
    });

    test(
        'When initializing, it fetches cached surveys correctly and returns CacheLoadingSuccess state',
        () {
      final surveysStream = homeViewModel.surveys;

      expect(surveysStream, emitsInOrder([cachedSurveys]));
      expect(
        providerContainer.read(homeViewModelProvider),
        const HomeState.cacheLoadingSuccess(),
      );
      verify(homeViewModel.loadSurveysFromCache()).called(1);
    });

    test(
        'When loads surveys from api with Success result, it emits SurveyModel list and returns ApiLoadingSuccess state',
        () async {
      when(mockGetSurveysUseCase.call(any))
          .thenAnswer((_) async => Success(surveys));
      final surveysStream = homeViewModel.surveys;
      final stateStream = homeViewModel.stream;

      expect(surveysStream, emitsInOrder([cachedSurveys, surveys]));
      expect(stateStream, emitsInOrder([HomeState.apiLoadingSuccess()]));

      homeViewModel.loadSurveysFromApi();
    });

    test(
        'When loads surveys from api with Failed result, it returns Error state',
        () {
      final exception = UseCaseException(Exception());
      when(mockGetSurveysUseCase.call(any))
          .thenAnswer((_) async => Failed(exception));
      final stateStream = homeViewModel.stream;

      expect(stateStream, emitsInOrder([HomeState.error(exception)]));

      homeViewModel.loadSurveysFromApi();
    });

    test(
        'When getting current date, it returns formatted current date correctly',
        () {
      withClock(Clock.fixed(DateTime(2000)), () {
        expect(homeViewModel.getCurrentDate(), "SATURDAY, JANUARY 01");
      });
    });
  });
}
