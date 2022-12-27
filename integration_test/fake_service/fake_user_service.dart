import 'package:flutter_test/flutter_test.dart';
import 'package:survey/api/response/user_response.dart';
import 'package:survey/api/service/user_service.dart';

import 'fake_data.dart';

const getUserKey = 'getUser';

class FakeUserService extends Fake implements UserService {
  @override
  Future<UserResponse> getUser() async {
    final response = FakeData.fakeResponses[getUserKey]!;

    if (response.statusCode != successStatusCode) {
      throw fakeDioError(response.statusCode);
    }
    return UserResponse.fromJson(response.json);
  }
}
