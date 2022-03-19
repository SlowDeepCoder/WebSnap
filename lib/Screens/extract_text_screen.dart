import 'package:flutter/material.dart';
import '../Components/gradient_app_bar_container.dart';
import '../Components/Buttons/gradient_floating_action_bar.dart';
import '../Tools/external_apps.dart';

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
          flexibleSpace: const GradientAppBarContainer(),
        ),
        floatingActionButton: GradientFloatingActionBar(
          onPressed: () => ExternalApps.openText(path),
          icon: Icons.edit,
        ),
        body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: SelectableText(
                  extractedText,
                  style: const TextStyle(fontSize: 16),
                ))));
  }
}
