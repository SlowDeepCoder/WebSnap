import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import '../Managers/string_manager.dart';

class Screenshot  {
  late final ImageProvider _image;
  late final String _name, _path, _url;

  Screenshot(this._image, this._name, this._path, this._url);

  ImageProvider getImage(){
    return _image;
  }
  String getName(){
    return _name;
  }
  String getPath(){
    return _path;
  }
  String getUrl(){
    return _url;
  }


  Screenshot.create(String url, Uint8List memoryImage, String localPath){
    _image = Image.memory(memoryImage).image;
    _name = StringManager.getScreenshotNameFromUrl(url);
    _path = localPath + '/$_name.png';
    _url = url;
  }

}