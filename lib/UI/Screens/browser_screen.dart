import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:test_flutter/Managers/data_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Components/Containers/gradient_app_bar_container.dart';

class BrowserScreen extends StatefulWidget {
  final String initialUrl;

  const BrowserScreen({Key? key, required this.initialUrl}) : super(key: key);

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  final _urlController = TextEditingController();
  late WebViewController _webViewController;
  final _urlFocusNode = FocusNode();
  late String _url;

  @override
  void initState() {
    super.initState();
    final url = _getUrlFromString(widget.initialUrl);
    _setUrl(url);
    WebView.platform = SurfaceAndroidWebView();
    _urlController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _urlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: WebView(
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              navigationDelegate: (NavigationRequest request) {
                _setUrl(request.url);
                return NavigationDecision.navigate;
              },
              initialUrl: _url,
              javascriptMode: JavascriptMode.unrestricted)),
      appBar: AppBar(
        title: TextField(
          onTap: () {
            _urlController.selection = TextSelection(
                baseOffset: 0, extentOffset: _urlController.text.length);
          },
          focusNode: _urlFocusNode,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            _onSearchSubmitted(value);
          },
          controller: _urlController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a search term',
          ),
        ),
        flexibleSpace: const GradientAppBarContainer(),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: _appBarButton(),
          ),
        ],
      ),
    );
  }

  Widget _appBarButton() {
    return IconButton(
        onPressed: _urlFocusNode.hasFocus
            ? () => _onSearchSubmitted(_urlController.text)
            : () => _onSubmitPressed(),
        icon: Icon(
          _urlFocusNode.hasFocus ? Icons.search : Icons.check,
          size: 30,
          color: Colors.white,
        ));
  }

  void _onSearchSubmitted(String value) async {
    FocusScope.of(context).unfocus();
    final url = _getUrlFromString(value);
    await _webViewController.loadUrl(url);
    if (mounted) {
      setState(() {
        _setUrl(url);
        debugPrint(url);
      });
    }
  }

  String _getUrlFromString(String value) {
    String url;
    if (value.contains(".")) {
      url = value.replaceAll(" ", "");
    } else {
      String query = value.trim().replaceAll(" ", "+");
      url = "https://www.google.com/search?q=" + query;
    }
    return DataManager.encodeUrl(url);
  }

  void _setUrl(String url) {
    _url = url;
    _urlController.text = _url;
  }

  void _onSubmitPressed() {
    Navigator.pop(context, _urlController.text);
  }
}
