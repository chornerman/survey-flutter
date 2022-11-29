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
    late MockGetUserUseCase mockGetUserUseCase;
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
      mockGetUserUseCase = MockGetUserUseCase();
      mockGetSurveysUseCase = MockGetSurveysUseCase();
      mockGetCachedSurveysUseCase = MockGetCachedSurveysUseCase();

      when(mockGetCachedSurveysUseCase.call()).thenAnswer((_) => cachedSurveys);

      providerContainer = ProviderContainer(
        overrides: [
          homeViewModelProvider.overrideWithValue(HomeViewModel(
            mockGetUserUseCase,
            mockGetSurveysUseCase,
            mockGetCachedSurveysUseCase,
          )),
        ],
      );
      addTearDown(providerContainer.dispose);
      homeViewModel = providerContainer.read(homeViewModelProvider.notifier);
    });

    test(
        'When loading surveys from cache, it emits cached SurveyModel list and returns CacheLoadingSuccess state',
        () {
      final surveysStream = homeViewModel.surveys;
      final stateStream = homeViewModel.stream;

      expect(surveysStream, emitsInOrder([cachedSurveys]));
      expect(
          stateStream, emitsInOrder([const HomeState.cacheLoadingSuccess()]));

      homeViewModel.loadSurveysFromCache();
    });

    test(
        'When getting user from api with Success result, it emits UserModel correspondingly',
        () async {
      final user = MockUserModel();
      when(mockGetUserUseCase.call()).thenAnswer((_) async => Success(user));
      final userStream = homeViewModel.user;

      expect(userStream, emitsInOrder([user]));

      homeViewModel.getUser();
    });

    test(
        'When loading surveys from api with Success result, it emits SurveyModel list and returns ApiLoadingSuccess state',
        () async {
      when(mockGetSurveysUseCase.call(any))
          .thenAnswer((_) async => Success(surveys));
      final surveysStream = homeViewModel.surveys;
      final stateStream = homeViewModel.stream;

      expect(surveysStream, emitsInOrder([surveys]));
      expect(stateStream, emitsInOrder([const HomeState.apiLoadingSuccess()]));

      homeViewModel.loadSurveysFromApi();
    });

    test(
        'When loading surveys from api with Failed result, it returns LoadSurveysError state',
        () {
      final exception = UseCaseException(Exception());
      when(mockGetSurveysUseCase.call(any))
          .thenAnswer((_) async => Failed(exception));
      final stateStream = homeViewModel.stream;

      expect(stateStream, emitsInOrder([const HomeState.error()]));

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
