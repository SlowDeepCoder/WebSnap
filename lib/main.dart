import 'package:flutter/material.dart';
import '../Screens/screenshot_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../Screens/home_sceen.dart';
import 'constants.dart';
import 'Screens/browser_screen.dart';
import 'Screens/extract_text_screen.dart';
import 'firebase_options.dart';

List<String> testDeviceIds = ['B50FC8BE31C425D9097C072C9A6E529B'];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupMobileAds();
  initializeFirebase();
  runApp(const WebSnapApp());
}

void setupMobileAds(){
  MobileAds.instance.initialize();
  RequestConfiguration configuration =
  RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);
}

void initializeFirebase() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class WebSnapApp extends StatelessWidget {
  const WebSnapApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'To-Do List',
        initialRoute: '/home',
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => const HomeScreen(),
          '/screenshot': (context) => const ScreenshotScreen(),
          '/extracted_text': (context) => const ExtractTextScreen(),
          '/browser': (context) => BrowserScreen(initialUrl: ModalRoute.of(context)?.settings.arguments as String),
        },
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
