const String _grantTypePassword = 'password';
const String _grantTypeRefreshToken = 'refresh_token';

enum GrantType {
  password,
  refreshToken,
}

extension GrantTypeExtension on GrantType {
  static const values = {
    GrantType.password: _grantTypePassword,
    GrantType.refreshToken: _grantTypeRefreshToken
  };

  String get value => values[this] ?? "";
}
