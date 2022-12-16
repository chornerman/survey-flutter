import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _accessTokenKey = "accessToken";
const String _tokenTypeKey = "tokenType";
const String _refreshTokenKey = "refreshToken";

abstract class SharedPreferencesUtils {
  String get accessToken;

  String get tokenType;

  String get refreshToken;

  String get authToken;

  bool get isLoggedIn;

  void saveAccessToken(String accessToken);

  void saveTokenType(String tokenType);

  void saveRefreshToken(String refreshToken);

  void clear();
}

@Singleton(as: SharedPreferencesUtils)
class SharedPreferencesUtilsImpl extends SharedPreferencesUtils {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesUtilsImpl(this._sharedPreferences);

  @override
  String get accessToken => _sharedPreferences.getString(_accessTokenKey) ?? '';

  @override
  String get tokenType => _sharedPreferences.getString(_tokenTypeKey) ?? '';

  @override
  String get refreshToken =>
      _sharedPreferences.getString(_refreshTokenKey) ?? '';

  @override
  String get authToken => '$tokenType $accessToken';

  @override
  bool get isLoggedIn =>
      _sharedPreferences.containsKey(_accessTokenKey) &&
      _sharedPreferences.containsKey(_tokenTypeKey);

  @override
  void saveAccessToken(String accessToken) async {
    await _sharedPreferences.setString(_accessTokenKey, accessToken);
  }

  @override
  void saveTokenType(String tokenType) async {
    await _sharedPreferences.setString(_tokenTypeKey, tokenType);
  }

  @override
  void saveRefreshToken(String refreshToken) async {
    await _sharedPreferences.setString(_refreshTokenKey, refreshToken);
  }

  @override
  void clear() async {
    await _sharedPreferences.clear();
  }
}
