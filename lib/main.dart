import 'package:flutter/material.dart';
import 'package:test_flutter/Models/screenshot.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'Models/extracted_text.dart';
import 'UI/Screens/extract_text_screen.dart';
import 'UI/Screens/home_screen.dart';
import 'UI/Screens/screenshot_screen.dart';
import 'UI/Screens/browser_screen.dart';
import 'Constants/color_constants.dart';
import 'firebase_options.dart';

List<String> testDeviceIds = ['B50FC8BE31C425D9097C072C9A6E529B'];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupMobileAds();
  initializeFirebase();
  runApp(const WebSnapApp());
}

void setupMobileAds() {
  MobileAds.instance.initialize();
  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);
}

void initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}


class WebSnapApp extends StatelessWidget {
  const WebSnapApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final routes = {
      '/home': (context) => const HomeScreen(),
      '/screenshot': (context) => ScreenshotScreen(
        screenshot:
        ModalRoute.of(context)?.settings.arguments as Screenshot,
      ),
      '/extracted_text': (context) => ExtractTextScreen(
        extractedText:
        ModalRoute.of(context)?.settings.arguments as ExtractedText,
      ),
      '/browser': (context) => BrowserScreen(
          initialUrl: ModalRoute.of(context)?.settings.arguments as String),
    };

    return MaterialApp(
        title: 'To-Do List',
        initialRoute: '/home',
        debugShowCheckedModeBanner: true,
        routes: routes,
        theme: ThemeData(
          fontFamily: 'Lato',
          primaryColor: ColorConstants.mainOrange,
          colorScheme: const ColorScheme.dark().copyWith(
            primary: ColorConstants.mainOrange,
            surface: ColorConstants.appBarOrange,
            secondary: Colors.green,
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all(ColorConstants.mainOrange),
          ),
        ));
  }
}
