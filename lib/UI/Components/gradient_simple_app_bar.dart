import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Containers/gradient_app_bar_container.dart';

// A SimpleAppBar is a AppBar with a title and a single action.
class GradientSimpleAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool hasLogo;
  final IconData icon;
  final VoidCallback onPressed;

  const GradientSimpleAppBar(
      {Key? key,
      required this.title,
      required this.onPressed,
      required this.icon,
      required this.hasLogo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        titleSpacing: 0.0,
        title: Row(
          children: <Widget>[
            _getLogoImage(),
            SizedBox(
              width: MediaQuery.of(context).size.width - 150,
              child: Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: hasLogo ? 25 : 16)),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: onPressed,
                icon: Icon(
                  icon,
                  size: 30,
                  color: Colors.white,
                )),
          ),
        ],
        flexibleSpace: const GradientAppBarContainer());
  }

  Widget _getLogoImage() {
    return hasLogo
        ? const Image(
            image: AssetImage('assets/images/foreground6.png'),
            height: 75,
          )
        : Container();
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
