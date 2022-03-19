import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../Constants.dart';

class BrowserScreen extends StatefulWidget {
  final String initialUrl;

  const BrowserScreen({Key? key, required this.initialUrl}) : super(key: key);

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  final TextEditingController _urlController = TextEditingController();
  final _urlFocusNode = FocusNode();
  late final StreamSubscription _urlChangeListener;
  final _flutterWebViewPlugin = FlutterWebviewPlugin();
  late String _url;

  @override
  void initState() {
    super.initState();
    _setUrl(widget.initialUrl);
    _addUrlListeners();
  }

  void _addUrlListeners() {
    _urlChangeListener = _flutterWebViewPlugin.onUrlChanged.listen((event) {
      if (mounted) {
        setState(() {
          _urlController.text = event;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _urlChangeListener.cancel();
    _flutterWebViewPlugin.dispose();
    _urlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: _url,
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  ColorConstants.yellowFire,
                  ColorConstants.redFire
                ]),
          ),
        ),
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
            : () => _onCheckPressed(),
        icon: Icon(
          _urlFocusNode.hasFocus ? Icons.search : Icons.check,
          size: 30,
          color: Colors.white,
        ));
  }

  void _onSearchSubmitted(String value) async {
    _setUrl(value);
    FocusScope.of(context).unfocus();
    await _flutterWebViewPlugin.reloadUrl(_url);
    if (mounted) {
      setState(() {
        debugPrint(_url);
      });
    }
  }

  void _setUrl(String value) {
    if (value.contains(".")) {
      _url = value.replaceAll(" ", "");
    } else {
      String query = value.trim().replaceAll(" ", "+");
      _url = "www.google.com/search?q=" + query;
    }
    _urlController.text = _url;
  }

  void _onCheckPressed() {
    Navigator.pop(context, _urlController.text);
  }
}
