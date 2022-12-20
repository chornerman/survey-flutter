import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/subjects.dart';
import 'package:survey/api/request/submit_survey_request.dart';
import 'package:survey/api/response/question_response.dart';
import 'package:survey/model/answer_model.dart';
import 'package:survey/model/question_model.dart';
import 'package:survey/model/survey_detail_model.dart';
import 'package:survey/page/questions/questions_state.dart';

class QuestionsViewModel extends StateNotifier<QuestionsState> {
  QuestionsViewModel() : super(const QuestionsState.init());

  final BehaviorSubject<List<QuestionModel>> _questions = BehaviorSubject();

  Stream<List<QuestionModel>> get questions => _questions.stream;

  final List<SubmitSurveyQuestionRequest> _submitSurveyQuestions = [];

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
      [SubmitSurveyAnswerRequest.fromAnswerModel(answer)],
    );
  }

  void _saveAnswers(
    String questionId,
    List<SubmitSurveyAnswerRequest> answers,
  ) {
    final question = _submitSurveyQuestions
        .firstWhereOrNull((question) => question.id == questionId);

    if (question == null) {
      _submitSurveyQuestions.add(SubmitSurveyQuestionRequest(
        id: questionId,
        answers: answers,
      ));
    } else {
      question.answers.clear();
      question.answers.addAll(answers);
    }
  }
}
