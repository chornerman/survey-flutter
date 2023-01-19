import 'package:flutter_test/flutter_test.dart';
import 'package:survey/api/request/login_request.dart';
import 'package:survey/api/request/reset_password_request.dart';
import 'package:survey/api/response/token_response.dart';
import 'package:survey/api/service/auth_service.dart';

import 'fake_data.dart';

const loginKey = 'login';
const resetPasswordKey = 'resetPassword';

class FakeAuthService extends Fake implements AuthService {
  @override
  Future<TokenResponse> login(LoginRequest body) async {
    final response = FakeData.fakeResponses[loginKey]!;

    if (response.statusCode != successStatusCode) {
      throw fakeDioError(response.statusCode);
    }
    return TokenResponse.fromJson(response.json);
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest body) async {
    final response = FakeData.fakeResponses[resetPasswordKey]!;

    if (response.statusCode != successStatusCode) {
      throw fakeDioError(response.statusCode);
    }
  }
}
