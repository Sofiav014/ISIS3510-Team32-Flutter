import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFailedToAuthenticateError(BuildContext context) {
  Flushbar(
    title: "Failed to authenticate client",
    message: "Please check your internet connection and try again",
    icon: const Icon(
      Icons.error_outline_outlined,
      size: 16,
      color: Colors.red,
    ),
    leftBarIndicatorColor: Colors.redAccent,
    duration: const Duration(seconds: 5),
  ).show(context);
}

void showNoConnectionError(BuildContext context) {
  Flushbar(
    title: "No Internet Connection",
    message:
        "Please check your internet connection. The app may be displaying outdated data.",
    icon: const Icon(
      Icons.warning,
      size: 16,
      color: Colors.orangeAccent,
    ),
    leftBarIndicatorColor: Colors.orangeAccent,
    duration: const Duration(seconds: 5),
  ).show(context);
}
