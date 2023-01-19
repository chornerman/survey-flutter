import 'package:dio/dio.dart';

const successStatusCode = 200;
const _errorStatusCode = 400;

class FakeResponse {
  final int statusCode;
  final Map<String, dynamic> json;

  FakeResponse(this.statusCode, this.json);
}

class FakeData {
  FakeData._();

  static Map<String, FakeResponse> fakeResponses = {};

  static void addSuccessResponse(String key, Map<String, dynamic> response) {
    final newResponse = FakeResponse(successStatusCode, response);
    fakeResponses.update(key, (response) => newResponse,
        ifAbsent: () => newResponse);
  }

  static void addErrorResponse(String key) {
    final newResponse = FakeResponse(_errorStatusCode, {});
    fakeResponses.update(key, (response) => newResponse,
        ifAbsent: () => newResponse);
  }
}

DioError fakeDioError(int statusCode) => DioError(
      response: Response(
          statusCode: statusCode, requestOptions: RequestOptions(path: '')),
      type: DioErrorType.response,
      requestOptions: RequestOptions(path: ''),
    );
