import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

import '../Models/screenshot.dart';

class ExternalApps{

  static void shareScreenshot(Screenshot screenshot) {
    Share.shareFiles([screenshot.getPath()]);
  }

  static void shareText(String path) {
    Share.shareFiles([path]);
  }


  static void openText(String path) {
    OpenFile.open(path);
  }

  static  void openScreenshot(Screenshot screenshot) {
    OpenFile.open(screenshot.getPath());
  }

}