import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class FileUtils {
  FileUtils._();

  static Future<Map<String, dynamic>> loadFile(String filePath) {
    return rootBundle.loadString(filePath).then((json) => jsonDecode(json));
  }
}
