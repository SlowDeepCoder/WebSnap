import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:test_flutter/Components/gradient_simple_app_bar.dart';
import 'package:test_flutter/constants.dart';
import '../Components/gradient_app_bar_container.dart';
import '../Managers/api_manager.dart';
import '../Managers/dialog_manager.dart';
import '../Managers/toast_manager.dart';
import '../Models/extracted_text.dart';
import '../Tools/permissions.dart';
import '../Components/Buttons/extract_data_button.dart';
import '../Components/banner_ad.dart';
import '../Components/query_form.dart';
import '../Managers/ad_manager.dart';
import '../Managers/string_manager.dart';
import '../Models/screenshot.dart';
import '../Tools/firebase_logging.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<QueryFormState> _queryFormKey = GlobalKey();
  InterstitialAd? _interstitialAd;
  late OutputType _outputType;

  void _loadInterstitialAd() {
    final id = AdManager.getInterstitialAdId();
    debugPrint(id);
    InterstitialAd.load(
        adUnitId: id,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _interstitialAd?.fullScreenContentCallback =
                FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            }, onAdFailedToShowFullScreenContent: (ad, _) {
              ad.dispose();
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    _outputType = _queryFormKey.currentState?.getOutputType() ?? OutputType.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: GradientSimpleAppBar(
            title: "WebSnap", onPressed: _onSearchPressed, icon: Icons.search),
        body: Stack(children: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height - 150.0,
              child: SingleChildScrollView(
                  child: Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const HomeBannerAd(),
                    QueryForm(
                      key: _queryFormKey,
                      onRadioChange: () {
                        setState(() {
                          _outputType =
                              _queryFormKey.currentState?.getOutputType() ??
                                  OutputType.image;
                        });
                      },
                    ),
                  ],
                ),
              ))),
          Align(
              alignment: Alignment.bottomCenter,
              // Todo: Try to remove this column
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ExtractDataButton(
                      outputType: _outputType,
                      onScreenshotPressed: () {
                        Logger.event(name: "Take screenshot pressed");
                        bool validForm =
                            _queryFormKey.currentState?.checkFormValidity() ?? false;
                        if (validForm) {
                          _extractData(_outputType);
                        }
                      },
                      onExtractTextPressed: () {
                        bool validUrl =
                            _queryFormKey.currentState?.checkUrlValidity() ?? false;
                        if (validUrl) {
                          _extractData(_outputType);
                        }
                      })
                ],
              )),
        ]));
  }

  void _rollInterstitialAd(int max) async {
    int random = max > 0 ? Random().nextInt(max) : 0;
    if (random == 0) {
      debugPrint("Rolled Interstitial Ad");
      if (_interstitialAd != null) {
        await _interstitialAd!.show();
        _loadInterstitialAd();
      }
    } else {
      debugPrint("Missed Interstitial Ad");
    }
  }

  void _navigateToScreenshotScreen(Screenshot screenshot) {
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pushNamed(context, '/screenshot', arguments: screenshot);
    _rollInterstitialAd(0);
  }

  void _navigateToExtractedTextScreen(ExtractedText extractedText) {
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pushNamed(context, '/extracted_text', arguments: extractedText);
    _rollInterstitialAd(2);
  }

  void _onSearchPressed() async {
    FocusScope.of(context).unfocus();
    String url = _queryFormKey.currentState?.getUrl() ?? Constants.defaultUrl;
    _navigateToBrowserScreen(url);
  }

  void _navigateToBrowserScreen(String url) async {
    final result =
        await Navigator.pushNamed(context, '/browser', arguments: url);
    if (result != null) {
      _queryFormKey.currentState?.setUrl('$result');
    }
  }

  void _extractData(OutputType type) async {
    FocusScope.of(context).unfocus();
    await Permissions.checkStoragePermission();
    final url = _queryFormKey.currentState!.getUrl();
    if (type == OutputType.image) {
      _takeScreenshot(url);
    } else if (type == OutputType.text) {
      _extractText(url);
    }
  }

  void _extractText(String url) async {
    DialogManager.openLoadingDialog(context, "Extracting Text");
    final text = await APIManager.fetchExtractedText(url);
    if (text != null) {
      final localPath = await StringManager.getLocalPath();
      final extractedText = ExtractedText.create(text, url, localPath);
      await _saveExtractedText(extractedText);
      _navigateToExtractedTextScreen(extractedText);
    } else {
      onErrorLoadingUrl();
    }
  }

  void _takeScreenshot(String url) async {
    DialogManager.openLoadingDialog(context, "Taking Screenshot");
    final query = _queryFormKey.currentState?.getQuery() ?? "";
    final memoryImage = await APIManager.fetchScreenshot(url, query);
    if (memoryImage != null) {
      final localPath = await StringManager.getLocalPath();
      final screenshot = Screenshot.create(memoryImage, url, localPath);
      await _saveScreenshot(screenshot, memoryImage);
      _navigateToScreenshotScreen(screenshot);
    } else {
      onErrorLoadingUrl();
    }
  }

  void onErrorLoadingUrl() {
    ToastManager.showToast("Error loading page.\nPlease check url.", true);
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future _saveExtractedText(ExtractedText extractedText) async {
    await File(extractedText.getPath())
        .writeAsString(extractedText.getText())
        .then((_) => {})
        .catchError((error) {});
  }

  Future _saveScreenshot(Screenshot screenshot, Uint8List memoryImage) async {
    await File(screenshot.getPath())
        .writeAsBytes(memoryImage)
        .then((_) => {})
        .catchError((error) {});
  }
}
