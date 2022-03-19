import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_functions/cloud_functions.dart';

class APIManager {
  static const baseUrl = "https://api.apiflash.com/v1/urltoimage";

  static Future<Uint8List?> fetchScreenshot(String url, String query) async {
    final api = await _getAPIUrl(url, "&response_type=image&scroll_page=true$query");
    debugPrint(api);
    final response = await http.get(Uri.parse(api));
    final body = response.bodyBytes;
    if (body
        .toString()
        .length < 1000) {
      return null;
    }
    return response.bodyBytes;
  }

  static Future<String?> fetchExtractedText(String url) async {
    final api = await _getAPIUrl(url, "&response_type=json&extract_text=true");
    debugPrint(api);
    final response = await http.get(Uri.parse(api));
    final result = json.decode(response.body);
    final extractedText = result["extracted_text"];
    if (extractedText != null) {
      final textResponse = await http.get(Uri.parse(extractedText));
      final textResult = utf8.decode(textResponse.bodyBytes);
      return textResult;
    }
    return null;
  }


  static Future<String> _getAPIUrl(String url, String query) async {
    final key = await _fetchAPIKey();
    String encodedUrl = encodeUrl(url);
    String api =
        "$baseUrl?access_key=$key&url=$encodedUrl$query";
    if (kReleaseMode) {
      api = api + "&fresh=true";
    }
    return api;
  }


  static String encodeUrl(String url) {
    url = url.replaceAll(" ", "");
    if (!url.contains("https://")) {
      url = "https://" + url;
    }
    final encoded = Uri.encodeComponent(url);
    return encoded;
  }

  static Future<String> _fetchAPIKey() async {
    if (kReleaseMode) {
      final fetchKey = FirebaseFunctions.instance.httpsCallable('fetchKey');
      final keyResponse = await fetchKey();
      String key = keyResponse.data;
      return key;
    }
    return "194532ef715f46c2975d705dc4806ce8";
  }
}
