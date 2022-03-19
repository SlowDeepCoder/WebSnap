import 'package:flutter/cupertino.dart';

import '../Constants.dart';

class AppBarGradientContainer extends StatelessWidget {
  const AppBarGradientContainer({Key? key}) : super(key: key);

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
