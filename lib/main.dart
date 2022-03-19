import 'package:flutter/material.dart';
import '../Screens/ScreenshotScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../Screens/HomeSceen.dart';
import 'Constants.dart';
import 'Screens/BrowserScreen.dart';
import 'Screens/ExtractTextScreen.dart';
import 'Tools/Logger.dart';
import 'firebase_options.dart';

List<String> testDeviceIds = ['B50FC8BE31C425D9097C072C9A6E529B'];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Logger.event(name: "App opened");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
            // Define the default brightness and colors.
            // Define the default font family.
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

            // textTheme: const TextTheme(
            //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            // ),
            ));
  }
}
