import 'dart:convert';
import 'dart:io';

class FileUtils {
  FileUtils._();

  static Future<Map<String, dynamic>> loadFile(String filePath) async {
    final file = File(filePath);
    return jsonDecode(await file.readAsString());
  }
}
