import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class StringManager {
  static String getScreenshotNameFromUrl(String url) {
    const dotChar = ".";
    final dotCount = dotChar.allMatches(url).length;
    if (dotCount >= 2) {
      final startIndex = url.indexOf(dotChar);
      final endIndex = url.indexOf(dotChar, startIndex + 1);
      String urlHost =
          url.substring(startIndex + dotChar.length, endIndex).trim();
      debugPrint("urlHost: " + urlHost);
      final imageName = "screenshot_$urlHost" "_" +
          (Random().nextInt(100000) + 100).toString();
      return imageName;
    } else if (dotCount == 1) {
      final dotIndex = url.indexOf(dotChar);
      final urlHost = url.substring(0, dotIndex);
      debugPrint("urlHost: " + urlHost);
      final imageName = "snapshot_$urlHost" "_" +
          (Random().nextInt(100000) + 100).toString();
      return imageName;
    }
    return url;
  }

  static String getTextNameFromUrl(String url) {
    const dotChar = ".";
    final dotCount = dotChar.allMatches(url).length;
    if (dotCount >= 2) {
      final startIndex = url.indexOf(dotChar);
      final endIndex = url.indexOf(dotChar, startIndex + 1);
      String urlHost =
          url.substring(startIndex + dotChar.length, endIndex).trim();
      debugPrint("urlHost: " + urlHost);
      final imageName = "extracted_text_$urlHost" "_" +
          (Random().nextInt(100000) + 100).toString();
      return imageName;
    } else if (dotCount == 1) {
      final dotIndex = url.indexOf(dotChar);
      final urlHost = url.substring(0, dotIndex);
      debugPrint("urlHost: " + urlHost);
      final imageName = "extracted_$urlHost" "_" +
          (Random().nextInt(100000) + 100).toString();
      return imageName;
    }
    return url;
  }


  static Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    debugPrint(directory.path);
    return directory.path;
  }
}
