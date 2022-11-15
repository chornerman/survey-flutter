import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _surveyBoxName = 'survey';

@module
abstract class DatabaseModule {
  @singleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @singleton
  @preResolve
  Future<Box> get surveyBox => Hive.openBox(_surveyBoxName);
}
