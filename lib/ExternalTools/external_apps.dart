import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:test_flutter/Models/extracted_text.dart';
import '../Models/screenshot.dart';

class ExternalApps{
  static void shareScreenshot(Screenshot screenshot) {
    Share.shareFiles([screenshot.getPath()]);
  }

  static void shareText(ExtractedText extractedText) {
    Share.shareFiles([extractedText.getPath()]);
  }


  static void openText(ExtractedText extractedText) {
    OpenFile.open(extractedText.getPath());
  }

  static  void openScreenshot(Screenshot screenshot) {
    OpenFile.open(screenshot.getPath());
  }

}