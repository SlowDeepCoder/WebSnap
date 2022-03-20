import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import '../Managers/file_manager.dart';

class Screenshot {
  late final ImageProvider _image;
  late final String _path, _url;

  Screenshot(this._image, this._path, this._url);

  Screenshot.create(Uint8List memoryImage, String url, String localPath) {
    String fileName = FileManager.getScreenshotFileName(url);
    _image = Image.memory(memoryImage).image;
    _path = localPath + '/$fileName';
    _url = url;
  }

  ImageProvider getImage() {
    return _image;
  }

  String getPath() {
    return _path;
  }

  String getUrl() {
    return _url;
  }

  Future saveToPath(Uint8List memoryImage) async {
    await File(getPath())
        .writeAsBytes(memoryImage)
        .then((_) => {})
        .catchError((error) {});
  }
}
