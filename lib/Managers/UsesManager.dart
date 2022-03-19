// library test_flutter.monthly_users;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:simple_moment/simple_moment.dart';
// import '../Constants.dart';
// import '../Managers/APIManager.dart';
//
// class UsesManager {
//   static UsesManager? _instance;
//
//   UsesManager._internal();
//
//   factory UsesManager() => _instance ??= UsesManager._internal();
//
//   static const MONTHLY_USES_KEY = "monthly_uses";
//   static const RESET_TIMESTAMP_KEY = "reset_timestamp";
//   static const DAILY_ADS_WATCHED_KEY = "daily_ads_watched";
//
//   int _resetTimestamp = 0;
//   int _dailyUses = 0;
//   int _dailyAdsWatched = 0;
//   SharedPreferences? prefs = null;
//
//   Future increaseDailyUses() async {
//     _dailyUses++;
//     if (_dailyUses == 1 && _resetTimestamp == 0) {
//       final timestamp = await APIManager.fetchTimestamp();
//       await _setResetTimestamp(timestamp + Constants.MINUTE_IN_MILLIS * 5);
//     }
//     await _saveMonthlyUses();
//   }
//
//   Future increaseDailyAdsWatched() async {
//     _dailyAdsWatched++;
//     if (_dailyAdsWatched == 1 && _resetTimestamp == 0) {
//       final timestamp = await APIManager.fetchTimestamp();
//       await _setResetTimestamp(timestamp + Constants.MINUTE_IN_MILLIS * 5);
//     }
//     await _saveDailyAdsWatched();
//   }
//
//   Future reset() async {
//     _dailyUses  = 0;
//     _dailyAdsWatched = 0;
//     await _saveMonthlyUses();
//     await _saveDailyAdsWatched();
//     await _setResetTimestamp(0);
//   }
//
//   int getMonthlyUses() {
//     return _dailyUses;
//   }
//
//   int getDailyAdsWatched() {
//     return _dailyAdsWatched;
//   }
//
//   int getResetTimestamp() {
//     return _resetTimestamp;
//   }
//
//   Future _setResetTimestamp(int timestamp) async {
//     _resetTimestamp = timestamp;
//     await _saveResetTimestamp();
//   }
//
//   Future loadData() async {
//     await _loadMonthlyUses();
//     await _loadDailyAdsWatched();
//     await _loadResetTime();
//   }
//
//   Future _saveMonthlyUses() async {
//     prefs ??= await SharedPreferences.getInstance();
//     prefs!.setInt(MONTHLY_USES_KEY, _dailyUses);
//   }
//
//   Future _loadMonthlyUses() async {
//     prefs ??= await SharedPreferences.getInstance();
//     _dailyUses = prefs!.getInt(MONTHLY_USES_KEY) ?? 0;
//   }
//
//   Future _saveDailyAdsWatched() async {
//     prefs ??= await SharedPreferences.getInstance();
//     prefs!.setInt(DAILY_ADS_WATCHED_KEY, _dailyAdsWatched);
//   }
//
//   Future _loadDailyAdsWatched() async {
//     prefs ??= await SharedPreferences.getInstance();
//     _dailyAdsWatched = prefs!.getInt(DAILY_ADS_WATCHED_KEY) ?? 0;
//   }
//
//   Future _saveResetTimestamp() async {
//     prefs ??= await SharedPreferences.getInstance();
//     prefs!.setInt(RESET_TIMESTAMP_KEY, _resetTimestamp);
//   }
//
//   Future _loadResetTime() async {
//     prefs ??= await SharedPreferences.getInstance();
//     _resetTimestamp = prefs!.getInt(RESET_TIMESTAMP_KEY) ?? 0;
//   }
//
// }
