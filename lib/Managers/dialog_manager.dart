import 'package:flutter/material.dart';
import '../Dialogs/loading_dialog.dart';

class DialogManager {
  static void openLoadingDialog(BuildContext context, String title) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: widget,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return WillPopScope(
              onWillPop: () async => false, child: LoadingDialog(title: title));
        });
  }
}
