import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../Components/AppBarGradientContainer.dart';
import '../Components/Buttons/GradientFab.dart';
import '../Constants.dart';
import '../Models/Screenshot.dart';
import '../Tools/ExternalApps.dart';

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
          flexibleSpace: const AppBarGradientContainer(),
        ),
        floatingActionButton: GradientFab(
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
