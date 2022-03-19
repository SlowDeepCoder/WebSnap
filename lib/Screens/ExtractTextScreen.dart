import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import '../Tools/ExternalApps.dart';

class ExtractTextScreen extends StatelessWidget {
  const ExtractTextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    String url = arguments["url"];
    String path = arguments["path"];
    String extractedText = arguments["text"];
    return Scaffold(
        backgroundColor: const Color(0x00000000),
        appBar: AppBar(
          title: Text(url),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  onPressed: () {
                    ExternalApps.shareText(path);
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
              ExternalApps.openText(path );
            },
            backgroundColor: ColorConstants.mainOrange,
            child: Container(
              width: 60,
              height: 60,
              child: const Icon(
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
            )),
        body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: SelectableText(
                  extractedText,
                  style: TextStyle(fontSize: 16),
                ))));
  }
}
