import 'package:equatable/equatable.dart';
import 'package:survey/api/response/user_response.dart';

class UserModel extends Equatable {
  final String name;
  final String avatarUrl;

  UserModel({
    required this.name,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, avatarUrl];

  factory UserModel.fromResponse(UserResponse response) {
    return UserModel(
      name: response.name ?? "",
      avatarUrl: response.avatarUrl ?? "",
    );
  }
}
