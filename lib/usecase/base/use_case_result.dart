part of 'base_use_case.dart';

abstract class Result<T> {
  Result._();
}

class Success<T> extends Result<T> {
  final T value;

  Success(this.value) : super._();
}

class Failed<T> extends Result<T> {
  final UseCaseException exception;

  Failed(this.exception) : super._();

  String getErrorMessage() =>
      NetworkExceptions.getErrorMessage(exception.actualException);
}

class UseCaseException implements Exception {
  final NetworkExceptions actualException;

  UseCaseException(this.actualException);
}
