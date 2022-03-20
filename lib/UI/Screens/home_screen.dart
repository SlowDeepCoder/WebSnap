import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../Components/gradient_simple_app_bar.dart';
import '../../Managers/data_manager.dart';
import '../../Managers/dialog_manager.dart';
import '../../Managers/toast_manager.dart';
import '../../Models/extracted_text.dart';
import '../../Managers/permissions_manager.dart';
import '../../Constants/default_constants.dart';
import '../Components/Buttons/extract_data_button.dart';
import '../Components/banner_ad.dart';
import '../Components/query_form.dart';
import '../../Managers/ad_manager.dart';
import '../../Managers/file_manager.dart';
import '../../Models/screenshot.dart';
import '../../ExternalTools/firebase_logging.dart';

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
    // ToDo: Try to move this function to the AdManager class.
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
                        Analytics.log(name: "Take screenshot pressed");
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
    _popDialog();
    Navigator.pushNamed(context, '/screenshot', arguments: screenshot);
    _rollInterstitialAd(0);
  }

  void _navigateToExtractedTextScreen(ExtractedText extractedText) {
    _popDialog();
    Navigator.pushNamed(context, '/extracted_text', arguments: extractedText);
    _rollInterstitialAd(2);
  }


  void _navigateToBrowserScreen(String url) async {
    final result =
        await Navigator.pushNamed(context, '/browser', arguments: url);
    if (result != null) {
      _queryFormKey.currentState?.setUrl('$result');
    }
  }


  void _onSearchPressed() async {
    FocusScope.of(context).unfocus();
    String url = _queryFormKey.currentState?.getUrl() ?? DefaultConstants.defaultUrl;
    _navigateToBrowserScreen(url);
  }

  void _extractData(OutputType type) async {
    FocusScope.of(context).unfocus();
    await PermissionsManager.checkStoragePermission();
    final url = _queryFormKey.currentState!.getUrl();
    if (type == OutputType.image) {
      _takeScreenshot(url);
    } else if (type == OutputType.text) {
      _extractText(url);
    }
  }

  void _extractText(String url) async {
    DialogManager.openLoadingDialog(context, "Extracting Text");
    final text = await DataManager.fetchExtractedText(url);
    if (text != null) {
      final localPath = await FileManager.getLocalPath();
      final extractedText = ExtractedText.create(text, url, localPath);
      await extractedText.saveToPath();
      _navigateToExtractedTextScreen(extractedText);
    } else {
      onErrorLoadingUrl();
    }
  }

  void _takeScreenshot(String url) async {
    DialogManager.openLoadingDialog(context, "Taking Screenshot");
    final query = _queryFormKey.currentState?.getQuery() ?? "";
    final memoryImage = await DataManager.fetchScreenshot(url, query);
    if (memoryImage != null) {
      final localPath = await FileManager.getLocalPath();
      final screenshot = Screenshot.create(memoryImage, url, localPath);
      await screenshot.saveToPath(memoryImage);
      _navigateToScreenshotScreen(screenshot);
    } else {
      onErrorLoadingUrl();
    }
  }

  // Display a toast and pop the loading dialog.
  void onErrorLoadingUrl() {
    ToastManager.showToast("Error loading page.\nPlease check url.", true);
    _popDialog;
  }



  void _popDialog(){
    Navigator.of(context, rootNavigator: true).pop();
  }
}
