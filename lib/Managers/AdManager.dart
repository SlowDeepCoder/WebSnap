import '../Constants.dart';

class AdManager {
  static String getInterstitialAdId() {
    return Constants.isProduction
        ? "ca-app-pub-5097345552684987/2237001122"
        : "ca-app-pub-3940256099942544/8691691433";
  }

  static String getBannerAdId() {
    return Constants.isProduction
        ? "ca-app-pub-5097345552684987/1690206211"
        : "ca-app-pub-3940256099942544/6300978111";
  }
}
