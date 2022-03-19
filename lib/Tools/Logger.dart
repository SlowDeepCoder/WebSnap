import 'package:firebase_analytics/firebase_analytics.dart';
import '../Constants.dart';

class Logger {
  static event({required String name, Map<String, Object?>? parameters}) {
    if(Constants.isProduction) {
      name = name.replaceAll(" ", "_").toLowerCase();
      FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
    }
  }
}
