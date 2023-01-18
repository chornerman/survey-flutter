import 'package:flutter_test/flutter_test.dart';
import 'package:survey/api/request/login_request.dart';
import 'package:survey/api/response/token_response.dart';
import 'package:survey/api/service/auth_service.dart';

import 'fake_data.dart';

const loginKey = 'login';

class FakeAuthService extends Fake implements AuthService {
  @override
  Future<TokenResponse> login(LoginRequest body) async {
    final response = FakeData.fakeResponses[loginKey]!;

    if (response.statusCode != 200) {
      throw fakeDioError(response.statusCode);
    }
    return TokenResponse.fromJson(response.json);
  }
}
