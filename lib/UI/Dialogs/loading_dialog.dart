import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String title;
  const LoadingDialog({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
          elevation: 5,
          title: Text(
            title.toString(),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    strokeWidth: 15,
                  ))
            ],
          ));
    // });
  }
}
