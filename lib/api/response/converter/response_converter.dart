import 'package:japx/japx.dart';

Map<String, dynamic> fromDataJsonApi(Map<String, dynamic> json) =>
    json.containsKey('data') ? Japx.decode(json)['data'] : json;

Map<String, dynamic> fromRootJsonApi(Map<String, dynamic> json) {
  return Japx.decode(json);
}
