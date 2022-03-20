import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../Components/Buttons/gradient_floating_action_bar.dart';
import '../Components/gradient_simple_app_bar.dart';
import '../Models/screenshot.dart';
import '../Tools/external_apps.dart';

class ScreenshotScreen extends StatelessWidget {
  final Screenshot screenshot;

  const ScreenshotScreen({Key? key, required this.screenshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0x00000000),
        appBar: GradientSimpleAppBar(
            title: screenshot.getUrl(),
            onPressed: () => ExternalApps.shareScreenshot(screenshot),
            icon: Icons.share),
        floatingActionButton: GradientFloatingActionBar(
            onPressed: () => ExternalApps.openScreenshot(screenshot),
            icon: Icons.edit),
        body: PhotoView.customChild(
            minScale: PhotoViewComputedScale.contained * 1,
            maxScale: PhotoViewComputedScale.covered * 50,
            initialScale: PhotoViewComputedScale.contained,
            basePosition: Alignment.center,
            child: Padding(
                padding: const EdgeInsets.all(50),
                child: Image(
                  image: screenshot.getImage(),
                ))));
  }
}
