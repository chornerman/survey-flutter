import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/subjects.dart';
import 'package:survey/api/response/question_response.dart';
import 'package:survey/model/question_model.dart';
import 'package:survey/model/survey_detail_model.dart';
import 'package:survey/page/questions/questions_state.dart';

class QuestionsViewModel extends StateNotifier<QuestionsState> {
  QuestionsViewModel() : super(const QuestionsState.init());

  final BehaviorSubject<List<QuestionModel>> _questions = BehaviorSubject();

  Stream<List<QuestionModel>> get questions => _questions.stream;

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
}