import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survey/api/response/question_response.dart';
import 'package:survey/api/response/survey_detail_response.dart';
import 'package:survey/model/submit_survey_question_model.dart';
import 'package:survey/model/survey_detail_model.dart';
import 'package:survey/page/questions/questions_page.dart';
import 'package:survey/page/questions/questions_state.dart';
import 'package:survey/page/questions/questions_view_model.dart';

import '../../utils/file_utils.dart';

void main() {
  group('QuestionsViewModelTest', () {
    late ProviderContainer providerContainer;
    late QuestionsViewModel questionsViewModel;

    late SurveyDetailModel surveyDetail;

    setUp(() async {
      final surveyDetailJson = await FileUtils.loadFile(
          'test/mock/mock_response/survey_detail.json');
      final surveyDetailResponse =
          SurveyDetailResponse.fromJson(surveyDetailJson);
      surveyDetail = SurveyDetailModel.fromResponse(surveyDetailResponse);

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
        () {
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

    test(
        'When calling save dropdown answer, it adds SubmitSurveyQuestionModel correctly',
        () {
      final dropdownQuestion = surveyDetail.questions[11];
      final dropdownQuestionId = dropdownQuestion.id;
      final dropdownQuestionAnswer = dropdownQuestion.answers.first;

      questionsViewModel.getQuestions(surveyDetail);
      questionsViewModel.saveDropdownAnswer(
        dropdownQuestionId,
        dropdownQuestionAnswer,
      );

      expect(questionsViewModel.submitSurveyQuestions, [
        SubmitSurveyQuestionModel(
          id: dropdownQuestionId,
          answers: [
            SubmitSurveyAnswerModel.fromAnswerModel(dropdownQuestionAnswer)
          ],
        ),
      ]);
    });

    test(
        'When calling save rating bars answer, it adds SubmitSurveyQuestionModel correctly',
        () {
      final iconsRatingBarQuestion = surveyDetail.questions[1];
      final iconsRatingBarQuestionId = iconsRatingBarQuestion.id;
      final iconsRatingBarAnswer = iconsRatingBarQuestion.answers
          .firstWhereOrNull((answer) => answer.displayOrder == 0)!;

      questionsViewModel.getQuestions(surveyDetail);
      questionsViewModel.saveRatingBarsAnswer(iconsRatingBarQuestionId, 1);

      expect(questionsViewModel.submitSurveyQuestions, [
        SubmitSurveyQuestionModel(
          id: iconsRatingBarQuestionId,
          answers: [
            SubmitSurveyAnswerModel.fromAnswerModel(iconsRatingBarAnswer)
          ],
        ),
      ]);
    });

    test(
        'When calling save multiple choices answer, it adds SubmitSurveyQuestionModel correctly',
        () {
      final multipleChoicesQuestion = surveyDetail.questions[8];
      final multipleChoicesQuestionId = multipleChoicesQuestion.id;
      final multipleChoicesSubmitAnswers = [
        SubmitSurveyAnswerModel.fromAnswerModel(multipleChoicesQuestion.answers
            .firstWhereOrNull((answer) => answer.displayOrder == 0)!)
      ];

      questionsViewModel.getQuestions(surveyDetail);
      questionsViewModel.saveMultipleChoicesAnswer(
        multipleChoicesQuestionId,
        multipleChoicesSubmitAnswers,
      );

      expect(questionsViewModel.submitSurveyQuestions, [
        SubmitSurveyQuestionModel(
          id: multipleChoicesQuestionId,
          answers: multipleChoicesSubmitAnswers,
        ),
      ]);
    });

    test(
        'When calling save text fields answer, it adds SubmitSurveyQuestionModel correctly',
        () {
      final textFieldsQuestion = surveyDetail.questions[10];
      final textFieldsQuestionId = textFieldsQuestion.id;
      final textFieldsAnswer = textFieldsQuestion.answers
          .firstWhereOrNull((answer) => answer.displayOrder == 0)!;
      final textFieldsAnswerId = textFieldsAnswer.id;
      final input = 'text';

      questionsViewModel.getQuestions(surveyDetail);
      questionsViewModel.saveTextFieldsAnswer(
        textFieldsQuestionId,
        textFieldsAnswerId,
        input,
      );

      expect(questionsViewModel.submitSurveyQuestions, [
        SubmitSurveyQuestionModel(
          id: textFieldsQuestionId,
          answers: [
            SubmitSurveyAnswerModel(id: textFieldsAnswerId, answer: input)
          ],
        ),
      ]);
    });
  });
}
