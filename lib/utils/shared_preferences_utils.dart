import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyAccessToken = "accessToken";
const String _keyTokenType = "tokenType";
const String _keyRefreshToken = "refreshToken";

abstract class SharedPreferencesUtils {
  String get accessToken;

  String get tokenType;

  String get refreshToken;

  void saveAccessToken(String accessToken);

  void saveTokenType(String tokenType);

  void saveRefreshToken(String refreshToken);
}

@Singleton(as: SharedPreferencesUtils)
class SharedPreferencesUtilsImpl extends SharedPreferencesUtils {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesUtilsImpl(this._sharedPreferences);

  @override
  String get accessToken => _sharedPreferences.getString(_keyAccessToken) ?? '';

  @override
  String get tokenType => _sharedPreferences.getString(_keyTokenType) ?? '';

  @override
  String get refreshToken =>
      _sharedPreferences.getString(_keyRefreshToken) ?? '';

  @override
  void saveAccessToken(String accessToken) async {
    await _sharedPreferences.setString(_keyAccessToken, accessToken);
  }

  @override
  void saveTokenType(String tokenType) async {
    await _sharedPreferences.setString(_keyTokenType, tokenType);
  }

  @override
  void saveRefreshToken(String refreshToken) async {
    await _sharedPreferences.setString(_keyRefreshToken, refreshToken);
  }
}
