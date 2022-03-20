import 'package:permission_handler/permission_handler.dart';

class PermissionsManager {
  static Future checkStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }
}
