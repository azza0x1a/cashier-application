import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

showLoaderDialog(context) {
  Material loading = Material(
    color: Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: const Color(0xffFCE183),
                size: 50,
                secondRingColor: const Color(0xffF749A2),
                thirdRingColor: const Color(0xffF68D7F),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Loading...',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: 12
              ),
            ),
          ],
        )
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return loading;
    },
  );
}

hideLoaderDialog(context) {
  return Navigator.pop(context);
}
