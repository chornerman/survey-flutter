import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:survey/di/di.dart';
import 'package:survey/model/survey_model.dart';
import 'package:survey/page/home/home_state.dart';
import 'package:survey/page/home/home_view_model.dart';
import 'package:survey/page/home/widget/home_header_widget.dart';
import 'package:survey/page/home/widget/home_surveys_page_view_widget.dart';
import 'package:survey/usecase/get_cached_surveys_use_case.dart';
import 'package:survey/usecase/get_surveys_use_case.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>((ref) {
  return HomeViewModel(
    getIt.get<GetSurveysUseCase>(),
    getIt.get<GetCachedSurveysUseCase>(),
  );
});

final _surveysStreamProvider = StreamProvider.autoDispose<List<SurveyModel>>(
    (ref) => ref.watch(homeViewModelProvider.notifier).surveys);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    ref.read(homeViewModelProvider.notifier).loadSurveysFromApi();
  }

  @override
  Widget build(BuildContext context) {
    final surveys = ref.watch(_surveysStreamProvider).value ?? [];
    return ref.watch(homeViewModelProvider).when(
          init: () => _buildHomePage(surveys),
          loading: () => _buildHomePage(surveys),
          cacheLoadingSuccess: () => _buildHomePage(surveys),
          apiLoadingSuccess: () =>
              _buildHomePage(surveys, shouldEnablePagination: true),
          error: (exception) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showError(AppLocalizations.of(context)!.homeLoadSurveysError);
            });
            return _buildHomePage(surveys);
          },
        );
  }

  Widget _buildHomePage(
    List<SurveyModel> surveys, {
    bool shouldEnablePagination = false,
  }) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          HomeSurveysPageViewWidget(
            surveys: surveys,
            loadMoreSurveys: () => {
              if (shouldEnablePagination)
                ref.read(homeViewModelProvider.notifier).loadSurveysFromApi()
            },
          ),
          SafeArea(
            child: HomeHeaderWidget(
                currentDate:
                    ref.read(homeViewModelProvider.notifier).getCurrentDate()),
          ),
        ],
      ),
    );
  }

  void _showError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(errorMessage),
    ));
  }
}
