import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/api/exception/network_exceptions.dart';
import 'package:survey/api/repository/user_repository.dart';
import 'package:survey/api/response/user_response.dart';
import 'package:survey/model/user_model.dart';

import '../../mock/mock_dependencies.mocks.dart';
import '../../utils/file_utils.dart';

void main() {
  group("UserRepositoryTest", () {
    late MockUserService mockUserService;
    late UserRepository repository;

    setUp(() async {
      mockUserService = MockUserService();
      repository = UserRepositoryImpl(mockUserService);
    });

    test(
        'When calling getUser successfully, it returns corresponding mapped result',
        () async {
      final userJson = await FileUtils.loadFile('mock_response/user.json');
      final response = UserResponse.fromJson(userJson);

      when(mockUserService.getUser()).thenAnswer((_) async => response);
      final result = await repository.getUser();

      expect(result, UserModel.fromResponse(response));
    });

    test('When calling getUser failed, it returns NetworkExceptions error',
        () async {
      when(mockUserService.getUser()).thenThrow(MockDioError());

      result() => repository.getUser();

      expect(result, throwsA(isA<NetworkExceptions>()));
    });
  });
}
