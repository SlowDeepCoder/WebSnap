import 'package:flutter/cupertino.dart';
import '../constants.dart';

class GradientAppBarContainer extends StatelessWidget {
  const GradientAppBarContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              ColorConstants.yellowFire,
              ColorConstants.redFire
            ]),
      ),
    );
  }
}
