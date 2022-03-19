import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import '../Constants.dart';
import 'QueryForm.dart';

class TakeScreenshotButton extends StatefulWidget {
  final VoidCallback onScreenshotPressed;
  final VoidCallback onExtractTextPressed;
  final OutputType output;

  const TakeScreenshotButton(
      {Key? key,
      required this.onScreenshotPressed,
      required this.output,
      required this.onExtractTextPressed})
      : super(key: key);

  @override
  State<TakeScreenshotButton> createState() => _TakeScreenshotButtonState();
}

class _TakeScreenshotButtonState extends State<TakeScreenshotButton> {
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
    if (widget.output == OutputType.image) {
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
            callback: widget.onScreenshotPressed,
            increaseWidthBy: MediaQuery.of(context).size.width - 100,
            increaseHeightBy: 30,
            child: const Text("Take Screenshot",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
        ),
      );
    }

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
          callback: widget.onExtractTextPressed,
          increaseWidthBy: MediaQuery.of(context).size.width - 100,
          increaseHeightBy: 30,
          child: const Text("Extract Text",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
