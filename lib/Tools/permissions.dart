import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future checkStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      debugPrint("not garnted");
      await Permission.storage.request();
    }
  }
}
