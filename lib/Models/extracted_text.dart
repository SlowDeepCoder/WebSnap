import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import '../Managers/string_manager.dart';

class ExtractedText  {
  late final String _text;
  late final String  _path, _url;

  ExtractedText(this._text, this._path, this._url);

  String gettext(){
    return _text;
  }
  String getPath(){
    return _path;
  }
  String getUrl(){
    return _url;
  }


  ExtractedText.create(String text, String url, String localPath){
    String fileName = StringManager.getTextNameFromUrl(url);
    _text = text;
    _path = localPath + '/$fileName.txt';
    _url = url;
  }

}