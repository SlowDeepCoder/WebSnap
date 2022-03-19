import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import '../Managers/StringManager.dart';

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


  // Screenshot _createScreenshot(String url, Uint8List memoryImage) {
  //   String urlName = url.replaceAll("www.", "");
  //   if (urlName.length > 10) {
  //     urlName = url.substring(0, 10);
  //   }
  //   debugPrint("urlName");
  //   debugPrint(urlName);
  //   // final imageName = uri.host.split('.')[uri.host.split('.').length - 2];
  //   // debugPrint(name);
  //   // final startIndex = url.indexOf(".");
  //   // String urlName;
  //   // if (startIndex == -1) {
  //   //   urlName = url;
  //   // } else {
  //   //   final endIndex = url.indexOf(".", startIndex + 1);
  //   //   urlName = url.substring(startIndex + 1, endIndex).trim();
  //   // }
  //   final imageName =
  //       urlName + "_screenshot_" + (Random().nextInt(100000) + 100).toString();
  //   String imagePath = '/storage/emulated/0/Download/$imageName.png';
  //   final image = Image.memory(memoryImage).image;
  //   final screenshot = Screenshot(image, imageName, imagePath, url);

  //   return screenshot;
  // }
