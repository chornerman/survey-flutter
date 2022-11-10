import 'package:japx/japx.dart';

Map<String, dynamic> fromJsonApi(Map<String, dynamic> json) =>
    json.containsKey('data') ? Japx.decode(json)['data'] : json;
