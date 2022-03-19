import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
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
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    ColorConstants.yellowFire,
                    ColorConstants.redFire
                  ]),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ExternalApps.openScreenshot(screenshot);
          },
          backgroundColor: ColorConstants.mainOrange,
          child: Container(
            width: 60,
            height: 60,
            child: Icon(
              Icons.edit,
              size: 30,
            ),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    ColorConstants.yellowFire,
                    ColorConstants.redFire
                  ]),
            ),
          ),
        ),
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
