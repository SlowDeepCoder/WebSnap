import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import '../Managers/string_manager.dart';

class Screenshot {
  late final ImageProvider _image;
  late final String _path, _url;

  Screenshot(this._image, this._path, this._url);

  ImageProvider getImage() {
    return _image;
  }

  String getPath() {
    return _path;
  }

  String getUrl() {
    return _url;
  }

  Screenshot.create(Uint8List memoryImage, String url,  String localPath) {
    String fileName = StringManager.getScreenshotFileName(url);
    _image = Image.memory(memoryImage).image;
    _path = localPath + '/$fileName';
    _url = url;
  }
}
