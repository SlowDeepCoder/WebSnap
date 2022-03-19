import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../Components/gradient_app_bar_container.dart';
import '../Managers/api_manager.dart';
import '../Managers/dialog_manager.dart';
import '../Managers/toast_manager.dart';
import '../Tools/permissions.dart';
import '../Components/Buttons/take_screenshot_button.dart';
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
  final GlobalKey<QueryFormState> _formKey = GlobalKey();
  InterstitialAd? _interstitialAd;
  late OutputType _output;


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
    _output = _formKey.currentState?.getOutputType() ?? OutputType.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            titleSpacing: 0.0,
            title: Row(
              children: const <Widget>[
                Image(
                  image: AssetImage('assets/images/foreground6.png'),
                  height: 75,
                ),
                Text("WebSnap",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              ],
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                    onPressed: _onSearchPressed,
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.white,
                    )),
              ),
            ],
            flexibleSpace: const GradientAppBarContainer()),
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
                      key: _formKey,
                      onRadioChange: () {
                        setState(() {
                          _output = _formKey.currentState?.getOutputType() ??
                              OutputType.image;
                        });
                      },
                    ),
                  ],
                ),
              ))),
          Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TakeScreenshotButton(
                      output: _output,
                      onScreenshotPressed: () {
                        Logger.event(name: "Take screenshot pressed");
                        bool validForm =
                            _formKey.currentState?.checkFormValidity() ?? false;
                        if (validForm) {
                          _onTakeScreenshotPressed();
                        }
                      },
                      onExtractTextPressed: () {
                        bool validUrl =
                            _formKey.currentState?.checkUrlValidity() ?? false;
                        if (validUrl) {
                          _onExtractTextPressed();
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
    }
    else{
      debugPrint("Missed Interstitial Ad");
    }
  }

  void _navigateToScreenshotScreen(Screenshot screenshot) {
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pushNamed(context, '/screenshot', arguments: screenshot);
    _rollInterstitialAd(0);
  }

  void _navigateToExtractedTextScreen(String extractedText, String url, String path) {
    Navigator.of(context, rootNavigator: true).pop();
    Map hashmap = {"url": url, "text": extractedText, "path": path};
    Navigator.pushNamed(context, '/extracted_text', arguments: hashmap);
    _rollInterstitialAd(2);
  }


  void _onSearchPressed() async {
    FocusScope.of(context).unfocus();
    String url =
        _formKey.currentState?.getUrl() ?? "www.google.com";
    _navigateToBrowserScreen(url);
  }

  void _navigateToBrowserScreen(String url) async {
    final result =
        await Navigator.pushNamed(context, '/browser', arguments: url);
    if (result != null) {
      _formKey.currentState?.setUrl('$result');
    }
  }

  void _onExtractTextPressed() async {
    FocusScope.of(context).unfocus();
    await Permissions.checkStoragePermission();
    DialogManager.openLoadingDialog(context, "Extracting Text");
    final url = _formKey.currentState!.getUrl();
    final extractedText = await APIManager.fetchExtractedText(url);
    if (extractedText != null) {
      final name = StringManager.getTextNameFromUrl(url);
      final localPath = await StringManager.getLocalPath();
      final path = localPath + '/$name.txt';
      await _saveExtractedText(extractedText, path);
      _navigateToExtractedTextScreen(extractedText, url, path);
    } else {
      ToastManager.showToast("Error loading page.\nPlease check url.", true);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _onTakeScreenshotPressed() async {
    FocusScope.of(context).unfocus();
    await Permissions.checkStoragePermission();
    DialogManager.openLoadingDialog(context, "Taking Screenshot");
    final url = _formKey.currentState!.getUrl();
    final query = _formKey.currentState!.getQuery();
    final memoryImage = await APIManager.fetchScreenshot(url, query);
    if (memoryImage != null) {
      final localPath = await StringManager.getLocalPath();
      final screenshot = Screenshot.create(url, memoryImage, localPath);
      await _saveScreenshot(screenshot, memoryImage);
      _navigateToScreenshotScreen(screenshot);
    } else {
      ToastManager.showToast("Error loading page.\nPlease check url.", true);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future _saveExtractedText(String text, String path) async {
    await File(path).writeAsString(text).then((_) => {}).catchError((error) {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  Future _saveScreenshot(Screenshot screenshot, Uint8List memoryImage) async {
    await File(screenshot.getPath())
        .writeAsBytes(memoryImage)
        .then((_) => {})
        .catchError((error) {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }
}
