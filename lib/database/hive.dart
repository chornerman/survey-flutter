import 'package:hive_flutter/hive_flutter.dart';
import 'package:survey/model/survey_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SurveyModelAdapter());
}
