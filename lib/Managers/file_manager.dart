import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static String getNameFromUrl(String url) {
    const dotChar = ".";
    String name = "";
    final dotCount = dotChar.allMatches(url).length;
    if (dotCount >= 2) {
      final startIndex = url.indexOf(dotChar);
      final endIndex = url.indexOf(dotChar, startIndex + 1);
      name = url.substring(startIndex + dotChar.length, endIndex);
    } else if (dotCount == 1) {
      final endIndex = url.indexOf(dotChar);
      name = url.substring(0, endIndex);
    } else {
      name = url;
    }
    return name;
  }

  static String getScreenshotFileName(String url) {
    final name = getNameFromUrl(url);
    final randomInt = (Random().nextInt(100000) + 100);
    final fileName = "screenshot_${name}_$randomInt.png";
    return fileName;
  }



  static String getExtractedTextFileName(String url) {
    final name = getNameFromUrl(url);
    final randomInt = (Random().nextInt(100000) + 100);
    final fileName = "extracted_text_${name}_$randomInt.txt";
    return fileName;
  }

  static Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    debugPrint(directory.path);
    return directory.path;
  }
}
