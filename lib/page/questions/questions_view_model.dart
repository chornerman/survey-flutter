import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/subjects.dart';
import 'package:survey/api/response/question_response.dart';
import 'package:survey/model/answer_model.dart';
import 'package:survey/model/question_model.dart';
import 'package:survey/model/submit_survey_question_model.dart';
import 'package:survey/model/survey_detail_model.dart';
import 'package:survey/page/questions/questions_state.dart';
import 'package:survey/usecase/base/base_use_case.dart';
import 'package:survey/usecase/submit_survey_use_case.dart';

class QuestionsViewModel extends StateNotifier<QuestionsState> {
  final SubmitSurveyUseCase _submitSurveyUseCase;

  QuestionsViewModel(this._submitSurveyUseCase)
      : super(const QuestionsState.init());

  final BehaviorSubject<List<QuestionModel>> _questions = BehaviorSubject();

  Stream<List<QuestionModel>> get questions => _questions.stream;

  final List<SubmitSurveyQuestionModel> submitSurveyQuestions = [];

  String? _surveyId;

  String? _outroMessage;

  void getQuestions(SurveyDetailModel surveyDetail) {
    _surveyId = surveyDetail.id;
    final questions = surveyDetail.questions;

    // Store text from outro question to display in the Survey Completion page
    _outroMessage = questions
        .firstWhereOrNull(
            (question) => question.displayType == DisplayType.outro)
        ?.text;

    questions.removeWhere((question) =>
        question.displayType == DisplayType.intro ||
        question.displayType == DisplayType.outro);
    questions.sort((question1, question2) =>
        question1.displayOrder.compareTo(question2.displayOrder));
    _questions.add(questions);

    state = const QuestionsState.initSuccess();
  }

  void saveDropdownAnswer(String questionId, AnswerModel answer) {
    _saveAnswers(
      questionId,
      [SubmitSurveyAnswerModel.fromAnswerModel(answer)],
    );
  }

  void saveRatingBarsAnswer(String questionId, int rating) {
    final answers = _getAnswersByQuestionId(questionId);
    final selectedAnswer = answers
        ?.firstWhereOrNull((answer) => answer.displayOrder == rating - 1);
    final submitAnswers = selectedAnswer != null
        ? [SubmitSurveyAnswerModel.fromAnswerModel(selectedAnswer)]
        : <SubmitSurveyAnswerModel>[];

    _saveAnswers(questionId, submitAnswers);
  }

  void saveMultipleChoicesAnswer(
    String questionId,
    List<SubmitSurveyAnswerModel> submitAnswers,
  ) {
    _saveAnswers(questionId, submitAnswers);
  }

  void saveTextFieldsAnswer(String questionId, String answerId, String text) {
    final submitQuestion = submitSurveyQuestions
        .firstWhereOrNull((question) => question.id == questionId);
    final submitAnswer = submitQuestion?.answers
        .firstWhereOrNull((answer) => answer.id == answerId);

    if (text.isNotEmpty) {
      final newSubmitAnswer = SubmitSurveyAnswerModel(
        id: answerId,
        answer: text,
      );
      if (submitQuestion == null) {
        submitSurveyQuestions.add(SubmitSurveyQuestionModel(
          id: questionId,
          answers: [newSubmitAnswer],
        ));
      } else if (submitAnswer == null) {
        submitQuestion.answers.add(newSubmitAnswer);
      } else {
        submitAnswer.answer = text;
      }
    } else if (submitQuestion != null && submitAnswer != null) {
      submitQuestion.answers.removeWhere((answer) => answer.id == answerId);
    }
  }

  void saveTextAreaAnswer(String questionId, String text) {
    final answers = _getAnswersByQuestionId(questionId);
    if (answers == null || answers.isEmpty) return;

    final submitAnswers = text.isNotEmpty
        ? [SubmitSurveyAnswerModel(id: answers.first.id, answer: text)]
        : <SubmitSurveyAnswerModel>[];
    _saveAnswers(questionId, submitAnswers);
  }

  void _saveAnswers(
    String questionId,
    List<SubmitSurveyAnswerModel> answers,
  ) {
    final question = submitSurveyQuestions
        .firstWhereOrNull((question) => question.id == questionId);

    if (question == null) {
      submitSurveyQuestions.add(SubmitSurveyQuestionModel(
        id: questionId,
        answers: answers,
      ));
    } else {
      question.answers.clear();
      question.answers.addAll(answers);
    }
  }

  void submitSurvey() async {
    state = const QuestionsState.loading();
    final result = await _submitSurveyUseCase.call(
      SubmitSurveyInput(
        surveyId: _surveyId ?? '',
        questions: submitSurveyQuestions,
      ),
    );
    if (result is Success<void>) {
      state = QuestionsState.submitSurveySuccess(_outroMessage);
    } else {
      state = QuestionsState.error((result as Failed).getErrorMessage());
    }
  }

  void clearError() => state = const QuestionsState.initSuccess();

  List<AnswerModel>? _getAnswersByQuestionId(String questionId) =>
      _questions.value
          .firstWhereOrNull((question) => question.id == questionId)
          ?.answers;

  @override
  void dispose() async {
    await _questions.close();
    super.dispose();
  }
}
