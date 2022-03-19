
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Managers/AdManager.dart';

class HomeBannerAd extends StatefulWidget {
  const HomeBannerAd({Key? key}) : super(key: key);

  @override
  State<HomeBannerAd> createState() => _HomeBannerAdState();
}

class _HomeBannerAdState extends State<HomeBannerAd> {
  AdWidget? adWidget;
  late BannerAd adBanner;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  @override
  Widget build(BuildContext context) {
    if (adWidget == null) {
      return Container();
    }
    return Container(
      alignment: Alignment.center,
      child: adWidget,
      width: 320,
      height: 50,
    );
  }

  void _loadBanner() async {
    final id = AdManager.getBannerAdId();
    debugPrint(id);
    adBanner = BannerAd(
      adUnitId: id,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
    await adBanner.load();
    if (mounted) {
      setState(() {
        adWidget = AdWidget(ad: adBanner);
      });
    }
  }
}
