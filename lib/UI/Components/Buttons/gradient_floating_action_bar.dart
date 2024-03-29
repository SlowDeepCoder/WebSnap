import 'package:flutter/material.dart';
import '../../../Constants/color_constants.dart';

class GradientFloatingActionBar extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const GradientFloatingActionBar({Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: ColorConstants.mainOrange,
        child: Container(
          width: 60,
          height: 60,
          child: Icon(
            icon,
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
        ));
  }
}
