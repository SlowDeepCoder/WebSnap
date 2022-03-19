import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../Components/gradient_app_bar_container.dart';
import '../Components/Buttons/gradient_floating_action_bar.dart';
import '../Models/screenshot.dart';
import '../Tools/external_apps.dart';

class ScreenshotScreen extends StatelessWidget {
  const ScreenshotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Screenshot screenshot =
        ModalRoute.of(context)!.settings.arguments as Screenshot;

    return Scaffold(
        backgroundColor: const Color(0x00000000),
        appBar: AppBar(
          title: Text(screenshot.getUrl()),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  onPressed: () {
                    ExternalApps.shareScreenshot(screenshot);
                  },
                  icon: const Icon(
                    Icons.share,
                    size: 30,
                    color: Colors.white,
                  )),
            ),
          ],
          flexibleSpace: const GradientAppBarContainer(),
        ),
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
