import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/subjects.dart';
import 'package:survey/api/response/question_response.dart';
import 'package:survey/model/answer_model.dart';
import 'package:survey/model/question_model.dart';
import 'package:survey/model/submit_survey_question_model.dart';
import 'package:survey/model/survey_detail_model.dart';
import 'package:survey/page/questions/questions_state.dart';

class QuestionsViewModel extends StateNotifier<QuestionsState> {
  QuestionsViewModel() : super(const QuestionsState.init());

  final BehaviorSubject<List<QuestionModel>> _questions = BehaviorSubject();

  Stream<List<QuestionModel>> get questions => _questions.stream;

  final List<SubmitSurveyQuestionModel> submitSurveyQuestions = [];

  void getQuestions(SurveyDetailModel surveyDetail) {
    final questions = surveyDetail.questions;
    questions.removeWhere((question) =>
        question.displayType == DisplayType.intro ||
        question.displayType == DisplayType.outro);
    questions.sort((question1, question2) =>
        question1.displayOrder.compareTo(question2.displayOrder));
    _questions.add(questions);
    state = const QuestionsState.success();
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

  List<AnswerModel>? _getAnswersByQuestionId(String questionId) =>
      _questions.value
          .firstWhereOrNull((question) => question.id == questionId)
          ?.answers;
}
