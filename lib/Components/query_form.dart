import 'dart:core';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

enum OutputType { image, text }

class QueryForm extends StatefulWidget {
  final VoidCallback onRadioChange;

  const QueryForm({Key? key, required this.onRadioChange}) : super(key: key);

  @override
  QueryFormState createState() => QueryFormState();
}

class QueryFormState extends State<QueryForm> {
  final _urlFormKey = GlobalKey<FormState>();
  final _fullFormKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _delayController = TextEditingController();
  bool _fullPage = true, _noAds = true, _noCookies = true, _mobile = false;
  bool _showUrlClearButton = false;
  OutputType _outputType = OutputType.image;

  @override
  void initState() {
    super.initState();
    _setStandardFormValues();
    _addControlListeners();
  }

  void _setStandardFormValues() {
    _urlController.text = Constants.defaultUrl;
    _widthController.text = "1920";
    _heightController.text = "1080";
    _delayController.text = "0";
  }

  void _addControlListeners() {
    _urlController.addListener(() {
      setState(() {
        _showUrlClearButton = _urlController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _fullFormKey,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Form(
                key: _urlFormKey,
                child: TextFormField(
                    controller: _urlController,
                    decoration: InputDecoration(
                        labelText: 'URL', suffixIcon: _urlClearButton()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an URL';
                      } else if (!value.toString().contains(".")) {
                        return 'Not a valid URL';
                      }
                      return null;
                    })),
          ),
          Row(
            children: <Widget>[
              QueryFormContainer(
                child: TextFormField(
                    controller: _widthController,
                    decoration:
                        const InputDecoration(labelText: 'Screen width'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a width';
                      } else if (int.tryParse(value.toString()) == null) {
                        return 'Not a number';
                      } else if (int.tryParse(value.toString())! < 0) {
                        return 'Not positive';
                      }
                      return null;
                    }),
              ),
              QueryFormContainer(
                child: TextFormField(
                    controller: _heightController,
                    decoration:
                        const InputDecoration(labelText: "Screen height"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a height';
                      } else if (int.tryParse(value.toString()) == null) {
                        return 'Not a number';
                      } else if (int.tryParse(value.toString())! < 0) {
                        return 'Not positive';
                      }
                      return null;
                    }),
              )
            ],
          ),
          Row(
            children: <Widget>[
              QueryFormContainer(
                child: RadioListTile<OutputType>(
                  activeColor: ColorConstants.mainOrange,
                  title: const Text("Screenshot"),
                  value: OutputType.image,
                  groupValue: _outputType,
                  onChanged: (OutputType? value) {
                    setState(() {
                      _outputType = value ?? OutputType.image;
                      widget.onRadioChange();
                    });
                  },
                ),
              ),
              QueryFormContainer(
                child: RadioListTile<OutputType>(
                  activeColor: ColorConstants.mainOrange,
                  title: const Text("Text"),
                  value: OutputType.text,
                  groupValue: _outputType,
                  onChanged: (OutputType? value) {
                    setState(() {
                      _outputType = value ?? OutputType.image;
                      widget.onRadioChange();
                    });
                  },
                ),
              )
            ],
          ),
          ExpansionTileCard(
            title: const Text("Advanced options"),
            expandedTextColor: ColorConstants.mainOrange,
            expandedColor: Theme.of(context).canvasColor,
            shadowColor: Theme.of(context).canvasColor,
            initiallyExpanded: false,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                width: MediaQuery.of(context).size.width - 75,
                child: TextFormField(
                    controller: _delayController,
                    decoration:
                        const InputDecoration(labelText: 'Delay (seconds)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      } else if (int.tryParse(value.toString()) == null) {
                        return 'Not a number';
                      } else if (int.tryParse(value.toString())! < 0) {
                        return 'Not positive';
                      }
                      return null;
                    }),
              ),
              Row(
                children: <Widget>[
                  QueryFormContainer(
                    child: CheckboxListTile(
                      title: const Text("No ads"),
                      value: _noAds,
                      onChanged: (newValue) {
                        setState(() {
                          _noAds = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                  ),
                  QueryFormContainer(
                    child: CheckboxListTile(
                      title: const Text("No cookies"),
                      value: _noCookies,
                      onChanged: (newValue) {
                        setState(() {
                          _noCookies = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  QueryFormContainer(
                    child: CheckboxListTile(
                      title: const Text("Full page"),
                      value: _fullPage,
                      onChanged: (newValue) {
                        setState(() {
                          _fullPage = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                  ),
                  QueryFormContainer(
                    child: CheckboxListTile(
                      title: const Text("Mobile"),
                      value: _mobile,
                      onChanged: (newValue) {
                        setState(() {
                          _mobile = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget? _urlClearButton() {
    return Visibility(
      child: IconButton(
        onPressed: () => _urlController.clear(),
        icon: const Icon(Icons.clear),
      ),
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: _showUrlClearButton,
    );
  }

  bool checkFormValidity() {
    final validForm = _fullFormKey.currentState?.validate() ?? false;
    final validUrl = _urlFormKey.currentState?.validate() ?? false;
    return validForm && validUrl;
  }

  OutputType getOutputType() {
    return _outputType;
  }

  bool checkUrlValidity() {
    return _urlFormKey.currentState!.validate();
  }

  String getUrl() {
    return _urlController.text.toLowerCase();
  }

  void setUrl(String url) {
    setState(() {
      _urlController.text = url.toLowerCase();
    });
  }

  int _getWidth() {
    return int.parse(_widthController.text);
  }

  int _getHeight() {
    return int.parse(_heightController.text);
  }

  int? _getDelay() {
    if (_delayController.text.isEmpty) {
      return null;
    }
    int delay = int.parse(_delayController.text);
    return delay > 10 ? 10 : delay;
  }

  String getQuery() {
    String query = "";
    query += "&full_page=" + _fullPage.toString();
    query += "&no_ads=" + _noAds.toString();
    query += "&no_cookie_banners=" + _noCookies.toString();
    query += "&height=" + _getHeight().toString();
    if (_mobile) {
      query += "&width=480";
    } else {
      query += "&width=" + _getWidth().toString();
    }
    if (_getDelay() != null) {
      query += "&delay=" + _getDelay().toString();
    }
    return query;
  }
}

class QueryFormContainer extends StatelessWidget {
  final Widget child;

  const QueryFormContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 2 - 25,
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: child);
  }
}
