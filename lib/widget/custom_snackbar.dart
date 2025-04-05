import 'package:flutter/material.dart';

class CustomSnackbar {
  static bool isShowing = false;

  static void show(BuildContext context, String message, {
    Duration duration = const Duration(seconds: 4),
    Color backgroundColor = Colors.lightBlue,
  }) {
    if (!isShowing) {
      isShowing = true;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          onVisible: () {},
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(
            bottom: 40,
            left: 10,
            right: 10
          ),
          showCloseIcon: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)
          ),
        ),
      ).closed.then((_) {
        isShowing = false;
      });
    }
  }
}