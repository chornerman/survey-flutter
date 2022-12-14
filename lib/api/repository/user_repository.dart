import 'package:injectable/injectable.dart';
import 'package:survey/api/service/user_service.dart';
import 'package:survey/model/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUser();
}

@Singleton(as: UserRepository)
class UserRepositoryImpl extends UserRepository {
  final UserService _userService;

  UserRepositoryImpl(this._userService);

  @override
  Future<UserModel> getUser() async {
    final response = await _userService.getUser();
    return UserModel.fromResponse(response);
  }
}
