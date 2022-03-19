import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import '../../constants.dart';
import '../query_form.dart';

class ExtractDataButton extends StatefulWidget {
  final VoidCallback onScreenshotPressed;
  final VoidCallback onExtractTextPressed;
  final OutputType outputType;

  const ExtractDataButton(
      {Key? key,
      required this.onScreenshotPressed,
      required this.outputType,
      required this.onExtractTextPressed})
      : super(key: key);

  @override
  State<ExtractDataButton> createState() => _ExtractDataButtonState();
}

class _ExtractDataButtonState extends State<ExtractDataButton> {
  bool _isKeyboard = false;
  late final StreamSubscription _keyboardSubscription;

  @override
  void initState() {
    super.initState();
    _setKeyboardListener();
  }

  void _setKeyboardListener() {
    final keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool isVisible) {
      _isKeyboard = isVisible;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _keyboardSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final extractScreenshot = widget.outputType == OutputType.image;
    return Visibility(
      visible: !_isKeyboard,
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 50,
        child: GradientButton(
          shapeRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
              colors: [ColorConstants.redFire, ColorConstants.yellowFire]),
          shadowColor: Gradients.rainbowBlue.colors.last.withOpacity(0.5),
          callback: extractScreenshot ? widget.onScreenshotPressed : widget.onExtractTextPressed,
          increaseWidthBy: MediaQuery.of(context).size.width - 100,
          increaseHeightBy: 30,
          child: Text(extractScreenshot ? "Take Screenshot" : "Extract Text",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
