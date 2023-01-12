import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survey/api/response/question_response.dart';
import 'package:survey/api/response/survey_detail_response.dart';
import 'package:survey/model/survey_detail_model.dart';
import 'package:survey/page/questions/questions_page.dart';
import 'package:survey/page/questions/questions_state.dart';
import 'package:survey/page/questions/questions_view_model.dart';

import '../../utils/file_utils.dart';

void main() {
  group('QuestionsViewModelTest', () {
    late ProviderContainer providerContainer;
    late QuestionsViewModel questionsViewModel;

    setUp(() {
      providerContainer = ProviderContainer(
        overrides: [
          questionsViewModelProvider.overrideWithValue(QuestionsViewModel()),
        ],
      );
      addTearDown(providerContainer.dispose);
      questionsViewModel =
          providerContainer.read(questionsViewModelProvider.notifier);
    });

    test('When initializing, it initializes with Init state', () {
      expect(
        providerContainer.read(questionsViewModelProvider),
        const QuestionsState.init(),
      );
    });

    test(
        'When calling get questions, it emits list of QuestionModel and returns Success state',
        () async {
      final surveyDetailJson = await FileUtils.loadFile(
          'test/mock/mock_response/survey_detail.json');
      final surveyDetailResponse =
          SurveyDetailResponse.fromJson(surveyDetailJson);
      final surveyDetail = SurveyDetailModel.fromResponse(surveyDetailResponse);

      final expectedQuestions = surveyDetail.questions;
      expectedQuestions.removeWhere((question) =>
          question.displayType == DisplayType.intro ||
          question.displayType == DisplayType.outro);
      expectedQuestions.sort((question1, question2) =>
          question1.displayOrder.compareTo(question2.displayOrder));

      final stateStream = questionsViewModel.stream;
      final questionsStream = questionsViewModel.questions;

      expect(stateStream, emitsInOrder([const QuestionsState.success()]));
      expect(questionsStream, emitsInOrder([expectedQuestions]));

      questionsViewModel.getQuestions(surveyDetail);
    });
  });
}
