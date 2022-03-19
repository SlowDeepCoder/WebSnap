import 'package:flutter/material.dart';

class CardDescriptionBox extends StatelessWidget {
  final String text;

  const CardDescriptionBox({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,
            )));
  }
}
