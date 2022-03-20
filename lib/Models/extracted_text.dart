import 'dart:io';
import '../Managers/file_manager.dart';

class ExtractedText {
  late final String _text;
  late final String _path, _url;

  ExtractedText(this._text, this._path, this._url);

  ExtractedText.create(String text, String url, String localPath) {
    String fileName = FileManager.getExtractedTextFileName(url);
    _text = text;
    _path = localPath + '/$fileName';
    _url = url;
  }

  String getText() {
    return _text;
  }

  String getPath() {
    return _path;
  }

  String getUrl() {
    return _url;
  }

  Future saveToPath() async {
    await File(getPath())
        .writeAsString(getText())
        .then((_) => {})
        .catchError((error) {});
  }
}
