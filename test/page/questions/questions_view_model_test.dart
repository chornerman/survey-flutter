import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/api/response/question_response.dart';
import 'package:survey/api/response/survey_detail_response.dart';
import 'package:survey/model/submit_survey_question_model.dart';
import 'package:survey/model/survey_detail_model.dart';
import 'package:survey/page/questions/questions_page.dart';
import 'package:survey/page/questions/questions_state.dart';
import 'package:survey/page/questions/questions_view_model.dart';
import 'package:survey/page/questions/uimodel/questions_ui_model.dart';
import 'package:survey/usecase/base/base_use_case.dart';

import '../../mock/mock_dependencies.mocks.dart';
import '../../utils/file_utils.dart';

void main() {
  group('QuestionsViewModelTest', () {
    late MockSubmitSurveyUseCase mockSubmitSurveyUseCase;
    late ProviderContainer providerContainer;
    late QuestionsViewModel questionsViewModel;

    late SurveyDetailModel surveyDetail;

    setUp(() async {
      mockSubmitSurveyUseCase = MockSubmitSurveyUseCase();

      final surveyDetailJson = await FileUtils.loadFile(
          'test/mock/mock_response/survey_detail.json');
      final surveyDetailResponse =
          SurveyDetailResponse.fromJson(surveyDetailJson);
      surveyDetail = SurveyDetailModel.fromResponse(surveyDetailResponse);

      providerContainer = ProviderContainer(
        overrides: [
          questionsViewModelProvider.overrideWithValue(QuestionsViewModel(
            mockSubmitSurveyUseCase,
          )),
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
        'When calling get questions, it emits list of QuestionModel and returns InitSuccess state',
        () async {
      final questionsUiModel = await getQuestionsUiModel();
      final expectedQuestions = questionsUiModel.questions;
      expectedQuestions.removeWhere((question) =>
          question.displayType == DisplayType.intro ||
          question.displayType == DisplayType.outro);
      expectedQuestions.sort((question1, question2) =>
          question1.displayOrder.compareTo(question2.displayOrder));
      final stateStream = questionsViewModel.stream;
      final questionsStream = questionsViewModel.questions;

      expect(stateStream, emitsInOrder([const QuestionsState.initSuccess()]));
      expect(questionsStream, emitsInOrder([expectedQuestions]));

      questionsViewModel.getQuestions(questionsUiModel);
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

      questionsViewModel.getQuestions(surveyDetail);
      questionsViewModel.saveRatingBarsAnswer(iconsRatingBarQuestionId, 1);

      expect(questionsViewModel.submitSurveyQuestions, [
        SubmitSurveyQuestionModel(
          id: iconsRatingBarQuestionId,
          answers: [
            SubmitSurveyAnswerModel.fromAnswerModel(
              iconsRatingBarQuestion.answers.first,
            )
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
        SubmitSurveyAnswerModel.fromAnswerModel(
          multipleChoicesQuestion.answers.first,
        )
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
      final textFieldsAnswerId = textFieldsQuestion.answers.first.id;
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

    test(
        'When calling save text area answer, it adds SubmitSurveyQuestionModel correctly',
        () {
      final textAreaQuestion = surveyDetail.questions[9];
      final textAreaQuestionId = textAreaQuestion.id;
      final input = 'text';

      questionsViewModel.getQuestions(surveyDetail);
      questionsViewModel.saveTextAreaAnswer(textAreaQuestionId, input);

      expect(questionsViewModel.submitSurveyQuestions, [
        SubmitSurveyQuestionModel(
          id: textAreaQuestionId,
          answers: [
            SubmitSurveyAnswerModel(
              id: textAreaQuestion.answers.first.id,
              answer: input,
            )
          ],
        ),
      ]);
    });

    test(
        'When calling submit survey with Success result, it returns SubmitSurveySuccess state with corresponding outroMessage',
        () async {
      final questionsUiModel = await getQuestionsUiModel();
      final outroMessage = questionsUiModel.questions
          .firstWhereOrNull(
              (question) => question.displayType == DisplayType.outro)
          ?.text;
      when(mockSubmitSurveyUseCase.call(any))
          .thenAnswer((_) async => Success(null));
      final stateStream = questionsViewModel.stream;

      expect(
          stateStream,
          emitsInOrder([
            const QuestionsState.initSuccess(),
            const QuestionsState.loading(),
            QuestionsState.submitSurveySuccess(outroMessage),
          ]));

      questionsViewModel.getQuestions(questionsUiModel);
      questionsViewModel.submitSurvey();
    });

    test(
        'When calling submit survey with Failed result, it returns Error state with corresponding errorMessage',
        () {
      final mockException = MockUseCaseException();
      when(mockException.actualException)
          .thenReturn(NetworkExceptions.badRequest());
      when(mockSubmitSurveyUseCase.call(any))
          .thenAnswer((_) async => Failed(mockException));
      final stateStream = questionsViewModel.stream;

      expect(
          stateStream,
          emitsInOrder([
            const QuestionsState.loading(),
            QuestionsState.error(
              NetworkExceptions.getErrorMessage(NetworkExceptions.badRequest()),
            ),
          ]));

      questionsViewModel.submitSurvey();
    });
  });
}

Future<QuestionsUiModel> getQuestionsUiModel() async {
  final surveyDetailJson =
      await FileUtils.loadFile('test/mock/mock_response/survey_detail.json');
  final surveyDetailResponse = SurveyDetailResponse.fromJson(surveyDetailJson);
  final surveyDetail = SurveyDetailModel.fromResponse(surveyDetailResponse);
  return QuestionsUiModel(
    surveyId: 'surveyId',
    questions: surveyDetail.questions,
  );
}
