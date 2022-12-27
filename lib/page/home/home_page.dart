import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/constants.dart';
import 'package:survey/di/di.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/model/user_model.dart';
import 'package:survey/page/home/home_state.dart';
import 'package:survey/page/home/home_view_model.dart';
import 'package:survey/page/home/widget/home_header_widget.dart';
import 'package:survey/page/home/widget/home_skeleton_loading_widget.dart';
import 'package:survey/page/home/widget/home_surveys_indicators_widget.dart';
import 'package:survey/page/home/widget/home_surveys_page_view_widget.dart';
import 'package:survey/usecase/get_cached_surveys_use_case.dart';
import 'package:survey/usecase/get_surveys_use_case.dart';
import 'package:survey/usecase/get_user_use_case.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>((ref) {
  return HomeViewModel(
    getIt.get<GetUserUseCase>(),
    getIt.get<GetSurveysUseCase>(),
    getIt.get<GetCachedSurveysUseCase>(),
  );
});

final _surveysStreamProvider = StreamProvider.autoDispose<List<SurveyModel>>(
    (ref) => ref.watch(homeViewModelProvider.notifier).surveys);

final _userStreamProvider = StreamProvider.autoDispose<UserModel>(
    (ref) => ref.watch(homeViewModelProvider.notifier).user);

final _errorStreamProvider = StreamProvider.autoDispose<String>(
    (ref) => ref.watch(homeViewModelProvider.notifier).error);

final jumpToFirstSurveysPageStreamProvider = StreamProvider.autoDispose<void>(
    (ref) => ref.watch(homeViewModelProvider.notifier).jumpToFirstSurveysPage);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _currentSurveysPage = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    ref.read(homeViewModelProvider.notifier).getUser();
    ref.read(homeViewModelProvider.notifier).loadSurveysFromCache();
    ref.read(homeViewModelProvider.notifier).loadSurveysFromApi();
  }

  @override
  Widget build(BuildContext context) {
    final error = ref.watch(_errorStreamProvider).value;
    if (error != null) _showError(error);

    final surveys = ref.watch(_surveysStreamProvider).value ?? [];
    return ref.watch(homeViewModelProvider).when(
          init: () => HomeSkeletonLoadingWidget(),
          loading: () => _buildHomePage(
            surveys,
            shouldShowLoading: true,
          ),
          cacheLoadingSuccess: () => _buildHomePage(surveys),
          apiLoadingSuccess: () => _buildHomePage(
            surveys,
            shouldEnablePagination: true,
            shouldEnablePullToRefresh: true,
          ),
          loadSurveysError: () => _buildHomePage(
            surveys,
            shouldEnablePullToRefresh: true,
          ),
        );
  }

  Widget _buildHomePage(
    List<SurveyModel> surveys, {
    bool shouldShowLoading = false,
    bool shouldEnablePagination = false,
    bool shouldEnablePullToRefresh = false,
  }) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.white30,
        onRefresh: () =>
            ref.read(homeViewModelProvider.notifier).refreshSurveys(),
        child: Stack(
          children: [
            if (surveys.isNotEmpty) ...[
              HomeSurveysPageViewWidget(
                surveys: surveys,
                loadMoreSurveys: () => {
                  if (shouldEnablePagination)
                    ref
                        .read(homeViewModelProvider.notifier)
                        .loadSurveysFromApi()
                },
                currentSurveysPage: _currentSurveysPage,
              ),
              HomeSurveysIndicatorsWidget(
                surveysLength: surveys.length,
                currentSurveysPage: _currentSurveysPage,
              ),
            ],
            // Workaround to allow the page to be scrolled vertically to refresh on top
            if (shouldEnablePullToRefresh)
              FractionallySizedBox(
                heightFactor: 0.3,
                child: ListView(),
              ),
            SafeArea(
              child: HomeHeaderWidget(
                currentDate:
                    ref.read(homeViewModelProvider.notifier).getCurrentDate(),
                userAvatarUrl: ref.watch(_userStreamProvider).value?.avatarUrl,
              ),
            ),
            if (shouldShowLoading)
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
          ],
        ),
      ),
    );
  }

  void _showError(String errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: Constants.snackBarDurationInSecond),
        content: Text(errorMessage),
      ));
    });
  }

  @override
  void dispose() {
    _currentSurveysPage.dispose();
    super.dispose();
  }
}
