import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class Analytics {
  static log({required String name, Map<String, Object?>? parameters}) {
    if(kReleaseMode) {
      name = name.replaceAll(" ", "_").toLowerCase();
      FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
    }
  }
}
