import 'package:flutter/material.dart';
import 'package:test_flutter/Models/extracted_text.dart';
import '../Components/Buttons/gradient_floating_action_bar.dart';
import '../Components/gradient_simple_app_bar.dart';
import '../Tools/external_apps.dart';

class ExtractTextScreen extends StatelessWidget {
  final ExtractedText extractedText;
  const ExtractTextScreen({Key? key, required this.extractedText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0x00000000),
        appBar: GradientSimpleAppBar(
            title: extractedText.getUrl(),
            onPressed: () => ExternalApps.shareText(extractedText),
            icon: Icons.share),
        floatingActionButton: GradientFloatingActionBar(
          onPressed: () => ExternalApps.openText(extractedText.getPath()),
          icon: Icons.edit,
        ),
        body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: SelectableText(
                  extractedText.getText(),
                  style: const TextStyle(fontSize: 16),
                ))));
  }
}
